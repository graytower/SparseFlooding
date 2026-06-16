#!/bin/bash
currTime=$(date +"%m-%d-%H_%M_%S")
mkdir ./48node$currTime
sleep 1m
Num=97
for ((i=1;i<Num;i++));do
	eval tPid=$(ps aux|grep "tcpdump -i any net 10.8.0.0/16 -w /usr/local/node$i.cap"|grep "systemd+" |awk '{print $2}')
	sudo kill -2 $tPid
	eval docker cp node$i:/usr/local/node$i.cap ./48node$currTime
done
for ((i=1;i<Num;i++));do
	eval docker cp node$i:/usr/local/node$i.cap ./48node$currTime
done
cp logfile.log ./48node$currTime
cd ./48node$currTime
mergecap -a $(echo `ls |grep 'node*'`) -w result.cap
cd ..
#eval rsync -av ./48node$currTime ruser@10.28.187.187::test
