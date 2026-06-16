#!/bin/bash 
Num=97
tNUm=40
if [[ ! -d /var/run/netns  ]]; then
    #statements
    sudo mkdir /var/run/netns
fi
#build the containers
for((i=1;i<Num;i++));do
    eval docker run -itd --name node$i --privileged=true quagga
    eval PID$i=$(docker inspect -f'{{.State.Pid}}' node$i)
    eval sudo ln -s /proc/\$PID$i/ns/net /var/run/netns/\$PID$i
done

#echo "netns finish"
#configure the net
function getUpNode(){
    if (( $1%12==0 ))
    then
        return $(($1 - 11))
    else
   
        return $(($1 + 1))
    fi
}
function getRightNode(){
    if (( $1>=5&&$1<=9 ))||(( $1>=17&&$1<=21 ))||(( $1>=29&&$1<=32 ))||(( $1>=41&&$1<=44 ))||(( $1>=53&&$1<=56 ))||(( $1>=65&&$1<=68 ))||(( $1>=76&&$1<=80 ))
    then
        return $(($1 + 12))
    elif (( $1>=2&&$1<=3 ))||(( $1==12 ))||(( $1>=14&&$1<=15 ))||(( $1==24 ))||(( $1>=26&&$1<=27 ))||(( $1==36 ))||(( $1==38 ))||(( $1==48 ))||(( $1==60 ))||(( $1==50 ))||(( $1>=71&&$1<=72 ))||(( $1==62 ))||(( $1>=83&&$1<=84 ))||(( $1==74 ))
    then
        return $(($1 + 11))
    elif (( $1==1 ))||(( $1==13 ))||(( $1==25 ))||(( $1==37 ))||(( $1==49 ))||(( $1==61 ))||(( $1==73 ))
    then
        return $(($1 + 23))
    else
        return 0
    fi
}
#build the veth pair
for((i=1;i<Num;i++));do
    getUpNode i
    UpNodeNum=$?
    getRightNode i
    RightNodeNum=$?
    if (( $RightNodeNum!=0 ))
    then
        eval sudo ip link add $i$RightNodeNum\$PID$i type veth peer name $RightNodeNum$i\$PID$RightNodeNum
        eval sudo ip link add $i$UpNodeNum\$PID$i type veth peer name $UpNodeNum$i\$PID$UpNodeNum
        eval sudo ip link set $i$RightNodeNum\$PID$i netns \$PID$i
        eval sudo ip link set $RightNodeNum$i\$PID$RightNodeNum netns \$PID$RightNodeNum
        eval sudo ip link set $i$UpNodeNum\$PID$i netns \$PID$i
        eval sudo ip link set $UpNodeNum$i\$PID$UpNodeNum netns \$PID$UpNodeNum
        eval sudo ip netns exec \$PID$i ip link set $i$RightNodeNum\$PID$i up
        eval sudo ip netns exec \$PID$i ip addr add 10.8.$((i*2)).1/24 dev $i$RightNodeNum\$PID$i
        eval sudo ip netns exec \$PID$i ip link set $i$UpNodeNum\$PID$i up
        eval sudo ip netns exec \$PID$i ip addr add 10.8.$((i*2-1)).1/24 dev $i$UpNodeNum\$PID$i
        eval sudo ip netns exec \$PID$RightNodeNum ip link set $RightNodeNum$i\$PID$RightNodeNum up
        eval sudo ip netns exec \$PID$RightNodeNum ip addr add 10.8.$((i*2)).2/24 dev $RightNodeNum$i\$PID$RightNodeNum
        eval sudo ip netns exec \$PID$UpNodeNum ip link set $UpNodeNum$i\$PID$UpNodeNum up
        eval sudo ip netns exec \$PID$UpNodeNum ip addr add 10.8.$((i*2-1)).2/24 dev $UpNodeNum$i\$PID$UpNodeNum
    else
        eval sudo ip link add $i$UpNodeNum\$PID$i type veth peer name $UpNodeNum$i\$PID$UpNodeNum
        eval sudo ip link set $i$UpNodeNum\$PID$i netns \$PID$i
        eval sudo ip link set $UpNodeNum$i\$PID$UpNodeNum netns \$PID$UpNodeNum
        eval sudo ip netns exec \$PID$i ip link set $i$UpNodeNum\$PID$i up
        eval sudo ip netns exec \$PID$i ip addr add 10.8.$((i*2-1)).1/24 dev $i$UpNodeNum\$PID$i
        eval sudo ip netns exec \$PID$UpNodeNum ip link set $UpNodeNum$i\$PID$UpNodeNum up
        eval sudo ip netns exec \$PID$UpNodeNum ip addr add 10.8.$((i*2-1)).2/24 dev $UpNodeNum$i\$PID$UpNodeNum
    fi
done
./set_ip.sh
echo "finish building net"
