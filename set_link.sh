#!/bin/bash
Num=97
#build the containers
for((i=1;i<Num;i++));do
    eval PID$i=$(docker inspect -f'{{.State.Pid}}' node$i)
done
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
function getLeftNode(){
    if (( $1>=17&&$1<=21 ))||(( $1>=29&&$1<=32 ))||(( $1>=41&&$1<=44 ))||(( $1>=53&&$1<=56 ))||(( $1>=65&&$1<=68 ))||(( $1>=76&&$1<=80 ))||(( $1>=88&&$1<=92 ))
    then
        return $(($1 - 12))
    elif (( $1>=13&&$1<=14 ))||(( $1==23 ))||(( $1>=25&&$1<=26 ))||(( $1==35 ))||(( $1>=37&&$1<=38 ))||(( $1==47 ))||(( $1==49 ))||(( $1==59 ))||(( $1==61 ))||(( $1==71 ))||(( $1==73 ))||(( $1>=82&&$1<=83 ))||(( $1==85 ))||(( $1>=94&&$1<=95 ))
    then
        return $(($1 - 11))
    elif (( $1==24 ))||(( $1==36 ))||(( $1==48 ))||(( $1==60 ))||(( $1==72 ))||(( $1==84 ))||(( $1==96 ))
    then
        return $(($1 - 23)) 
    else 
        return 0
    fi
}
function getDownNode(){
    if (( $1%12 == 1 )); then
        #statements
        return $(($1 + 11))
    else
        return $(($1 - 1))
    fi
}
function setLinkState(){
    currTime=$(date +"%Y-%m-%d %T")
    if [ "$3" = "up" ]; then
        #statements
        eval sudo ip netns exec \$PID$1 ip link set $1$2\$PID$1 up
        eval sudo ip netns exec \$PID$2 ip link set $2$1\$PID$2 up
        echo "$currTime set link between node$1 and node$2 UP" >>logfile.log
	echo "link between node$1 and node$2 is up"
    elif [ "$3" = "down" ]; then
            #statements
            eval sudo ip netns exec \$PID$1 ip link set $1$2\$PID$1 down
            eval sudo ip netns exec \$PID$2 ip link set $2$1\$PID$2 down
            echo "$currTime set link between node$1 and node$2 DOWN" >>logfile.log
            echo "link between node$1 and node$2 is down"
            else
                echo "link state set error"
    fi
}
setLinkState 3 14 down
# setLinkState 8 20 down
