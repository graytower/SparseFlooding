# syntax=docker/dockerfile:1

# 1. 基础构建环境
# 1. 基础构建环境
FROM alpine:3.18 as alpine-builder
# 替换为阿里云源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add \
        --no-cache \
        --update-cache \
        abuild \
        alpine-conf \
        alpine-sdk \
    && setup-apkcache /var/cache/apk \
    && mkdir -p /pkgs/apk \
    # [关键修改] 下面这行增加了 env_keep 配置，让 sudo 保留代理变量
    && echo 'Defaults env_keep += "http_proxy https_proxy ftp_proxy no_proxy"' >> /etc/sudoers \
    && echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN adduser -D -G abuild builder && su builder -c 'abuild-keygen -a -n'

# 2. 构建 libyang 依赖
# 2. 构建 libyang 依赖
FROM alpine-builder as alpine-apk-builder-libyang
RUN mkdir -p /src/libyang
COPY docker/alpine/libyang/APKBUILD /src/libyang
RUN chown -R builder /pkgs /src

# [建议新增] 在切换用户前，先用 root 更新一下索引，确保 builder 用户能读到
RUN apk update

USER builder
# [修改] 你的原始命令
RUN cd /src/libyang \
    && abuild checksum \
    && git init \
    && abuild -r -P /pkgs/apk

# 3. 源码编译准备 (最容易报错的阶段)
FROM alpine:3.18 as source-builder
# [修改] 同样替换源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN mkdir -p /src/alpine /pkgs/apk
COPY alpine/APKBUILD.in /src/alpine
COPY --from=alpine-apk-builder-libyang /pkgs/apk/src /pkgs/apk

# [关键修改] 安装本地构建的 apk 时，容易出现 Permission denied
# 我们尝试先更新索引，并显式指定允许不受信任
RUN cd /pkgs/apk && apk update && apk add --allow-untrusted */*.apk

RUN source /src/alpine/APKBUILD.in \
    && apk add \
        --no-cache \
        --update-cache \
        $makedepends \
    && pip install pytest
COPY . /src
ARG PKGVER
RUN cd /src \
    && ./bootstrap.sh \
    && ./configure \
        --enable-numeric-version \
        --with-pkg-extra-version="_git$PKGVER" \
    && make dist

# 4. 构建 FRR APK
FROM alpine-builder as alpine-apk-builder
COPY --from=source-builder /src/frr-*.tar.gz /src/alpine/* /dist/
COPY --from=alpine-apk-builder-libyang /pkgs/apk/src /pkgs/apk

# [关键修改] 同上，处理本地包安装
RUN cd /pkgs/apk && apk update && apk add --allow-untrusted */*.apk

RUN find /pkgs/apk -type f -name APKINDEX.tar.gz -delete
RUN chown -R builder /dist /pkgs
USER builder
RUN cd /dist \
    && abuild checksum \
    && git init \
    && abuild -r -P /pkgs/apk

# 5. 最终镜像
FROM alpine:3.18
# [修改] 替换源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN mkdir -p /pkgs/apk
COPY --from=alpine-apk-builder /pkgs/apk/ /pkgs/apk/
RUN apk add \
        --no-cache \
        --update-cache \
        tini \
    && apk add \
        --no-cache \
        --allow-untrusted /pkgs/apk/*/*.apk \
    && rm -rf /pkgs

# Own the config / PID files
RUN mkdir -p /var/run/frr
RUN chown -R frr:frr /etc/frr /var/run/frr

# Simple init manager for reaping processes and forwarding signals
ENTRYPOINT ["/sbin/tini", "--"]

# Default CMD starts watchfrr
COPY docker/alpine/docker-start /usr/lib/frr/docker-start
CMD ["/usr/lib/frr/docker-start"]