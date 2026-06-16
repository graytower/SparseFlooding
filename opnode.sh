#!/bin/bash
sleep 1m
Num=97
for ((i=1;i<Num;i++));do
	eval docker cp ./up_tcpdump.sh node$i:/usr/local/etc/up_tcpdump.sh
	gnome-terminal --tab --title=node$i -- bash -c "docker exec -it node$i /bin/bash /usr/local/etc/up_tcpdump.sh $i;exec bash"
done
