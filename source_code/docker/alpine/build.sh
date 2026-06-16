#!/bin/sh

set -e
set -x

# 设置你的代理地址 (根据你的 curl 输出来填)
MY_PROXY="http://10.103.238.246:7890"

GITREV="${GITREV:=dev}" # 固定为 dev 以利用缓存
PKGVER="0"

echo "Using Proxy: $MY_PROXY"

# 1. 构建 builder 镜像
docker build \
    --pull \
    --file=docker/alpine/Dockerfile \
    --build-arg="PKGVER=$PKGVER" \
    --build-arg="http_proxy=$MY_PROXY" \
    --build-arg="https_proxy=$MY_PROXY" \
    --tag="frr:alpine-builder-dev" \
    --target=alpine-builder \
    .

# 2. 构建 apk-builder 镜像
docker build \
    --pull \
    --file=docker/alpine/Dockerfile \
    --build-arg="PKGVER=$PKGVER" \
    --build-arg="http_proxy=$MY_PROXY" \
    --build-arg="https_proxy=$MY_PROXY" \
    --tag="frr:alpine-apk-builder-dev" \
    --target=alpine-apk-builder \
    .

# ... (中间的 cp 操作不变) ...
CONTAINER_ID="$(docker create "frr:alpine-apk-builder-dev")"
docker cp "${CONTAINER_ID}:/pkgs/" docker/alpine
docker rm "${CONTAINER_ID}"

# 3. 构建最终镜像
docker build \
    --file=docker/alpine/Dockerfile \
    --build-arg="PKGVER=$PKGVER" \
    --build-arg="http_proxy=$MY_PROXY" \
    --build-arg="https_proxy=$MY_PROXY" \
    --tag="frr:alpine-dev" \
    .

echo "Build finished."