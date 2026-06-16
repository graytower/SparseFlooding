#!/bin/bash 
Num=97
for((i=1;i<Num;i++));do
    eval PID$i=$(docker inspect -f'{{.State.Pid}}' node$i)
    cp ./quagga_deamon/example/ospfd.conf ./quagga_deamon/node$i
    cp ./quagga_deamon/example/zebra.conf ./quagga_deamon/node$i
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
    if (( $1>=17&&$1<=21 ))||(( $1>=29&&$1<=33 ))||(( $1>=41&&$1<=44 ))||(( $1>=53&&$1<=56 ))||(( $1>=65&&$1<=68 ))||(( $1>=76&&$1<=80 ))||(( $1>=88&&$1<=92 ))
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
for((i=1;i<Num;i++));do
	getUpNode i
	upnum=$?
	getRightNode i
	rignum=$?
	getLeftNode i
	leftnum=$?
	if (( $rignum!=0 ))
	then
	    if (( $leftnum!=0 ))
	    then
	        eval intnum=$i$rignum\$PID$i
	        eval sed -i 's/r1/node$i\_ospf/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/r1/node$i/g' ./quagga_deamon/node$i/zebra.conf
	        eval sed -i 's/v0102/$intnum/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/v0102/$intnum/g' ./quagga_deamon/node$i/zebra.conf
	        eval intnum=$i$upnum\$PID$i
	        eval sed -i 's/v0107/$intnum/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/v0107/$intnum/g' ./quagga_deamon/node$i/zebra.conf
	        eval intnum=$upnum$i\$PID$upnum
	        eval sed -i 's/v0109/$intnum/g' ./quagga_deamon/node$upnum/ospfd.conf
	        eval sed -i 's/v0109/$intnum/g' ./quagga_deamon/node$upnum/zebra.conf
	        eval intnum=$rignum$i\$PID$rignum
	        eval sed -i 's/v1111/$intnum/g' ./quagga_deamon/node$rignum/ospfd.conf
 	        eval sed -i 's/v1111/$intnum/g' ./quagga_deamon/node$rignum/zebra.conf
	        eval sed -i 's/10\.9\.0\.1/10\.8\.0\.$i/g' ./quagga_deamon/node$i/ospfd.conf
                #amend zebra.conf
	        eval sed -i 's/10\.9\.1\.1/10\.8\.$((i*2))\.1/g' ./quagga_deamon/node$i/zebra.conf
	        eval sed -i 's/10\.9\.3\.1/10\.8\.$((i*2-1))\.1/g' ./quagga_deamon/node$i/zebra.conf
	        eval sed -i 's/10\.9\.2\.1/10\.8\.$((i*2-1))\.2/g' ./quagga_deamon/node$upnum/zebra.conf
	        eval sed -i 's/10\.9\.4\.1/10\.8\.$((i*2))\.2/g' ./quagga_deamon/node$rignum/zebra.conf
	    else
	        eval intnum=$i$rignum\$PID$i
	        eval sed -i 's/r1/node$i\_ospf/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/r1/node$i/g' ./quagga_deamon/node$i/zebra.conf
	        eval sed -i 's/v0102/$intnum/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/v0102/$intnum/g' ./quagga_deamon/node$i/zebra.conf
	        eval intnum=$i$upnum\$PID$i
	        eval sed -i 's/v0107/$intnum/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/v0107/$intnum/g' ./quagga_deamon/node$i/zebra.conf
	        eval intnum=$upnum$i\$PID$upnum
	        eval sed -i 's/v0109/$intnum/g' ./quagga_deamon/node$upnum/ospfd.conf
	        eval sed -i 's/v0109/$intnum/g' ./quagga_deamon/node$upnum/zebra.conf
	        eval intnum=$rignum$i\$PID$rignum
	        eval sed -i 's/v1111/$intnum/g' ./quagga_deamon/node$rignum/ospfd.conf
 	        eval sed -i 's/v1111/$intnum/g' ./quagga_deamon/node$rignum/zebra.conf
	        eval sed -i 's/10\.9\.0\.1/10\.8\.0\.$i/g' ./quagga_deamon/node$i/ospfd.conf
                #amend zebra.conf
	        eval sed -i 's/10\.9\.1\.1/10\.8\.$((i*2))\.1/g' ./quagga_deamon/node$i/zebra.conf
	        eval sed -i 's/10\.9\.3\.1/10\.8\.$((i*2-1))\.1/g' ./quagga_deamon/node$i/zebra.conf
	        eval sed -i 's/10\.9\.2\.1/10\.8\.$((i*2-1))\.2/g' ./quagga_deamon/node$upnum/zebra.conf
	        eval sed -i 's/10\.9\.4\.1/10\.8\.$((i*2))\.2/g' ./quagga_deamon/node$rignum/zebra.conf
	        sed -i 's/interface\ v1111/\!/g' ./quagga_deamon/node$i/ospfd.conf
                sed -i 's/interface\ v1111/\!/g' ./quagga_deamon/node$i/zebra.conf
                sed -i 's/\ ip\ address\ 10\.9\.4\.1\/24/\!/g' ./quagga_deamon/node$i/zebra.conf
            fi
	else
	    if (( $leftnum!=0 ))
	    then
	        eval sed -i 's/r1/node$i\_ospf/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/r1/node$i/g' ./quagga_deamon/node$i/zebra.conf
	        eval intnum=$i$upnum\$PID$i
	        eval sed -i 's/v0107/$intnum/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/v0107/$intnum/g' ./quagga_deamon/node$i/zebra.conf
	        eval intnum=$upnum$i\$PID$upnum
	        eval sed -i 's/v0109/$intnum/g' ./quagga_deamon/node$upnum/ospfd.conf
	        eval sed -i 's/v0109/$intnum/g' ./quagga_deamon/node$upnum/zebra.conf
	        eval sed -i 's/10\.9\.0\.1/10\.8\.0\.$i/g' ./quagga_deamon/node$i/ospfd.conf
                #amend zebra.conf
	        eval sed -i 's/10\.9\.3\.1/10\.8\.$((i*2-1))\.1/g' ./quagga_deamon/node$i/zebra.conf
	        eval sed -i 's/10\.9\.2\.1/10\.8\.$((i*2-1))\.2/g' ./quagga_deamon/node$upnum/zebra.conf
	        sed -i 's/interface\ v0102/\!/g' ./quagga_deamon/node$i/ospfd.conf
                sed -i 's/interface\ v0102/\!/g' ./quagga_deamon/node$i/zebra.conf
                sed -i 's/\ ip\ address\ 10\.9\.1\.1\/24/\!/g' ./quagga_deamon/node$i/zebra.conf
            else
                eval sed -i 's/r1/node$i\_ospf/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/r1/node$i/g' ./quagga_deamon/node$i/zebra.conf
	        eval intnum=$i$upnum\$PID$i
	        eval sed -i 's/v0107/$intnum/g' ./quagga_deamon/node$i/ospfd.conf
	        eval sed -i 's/v0107/$intnum/g' ./quagga_deamon/node$i/zebra.conf
	        eval intnum=$upnum$i\$PID$upnum
	        eval sed -i 's/v0109/$intnum/g' ./quagga_deamon/node$upnum/ospfd.conf
	        eval sed -i 's/v0109/$intnum/g' ./quagga_deamon/node$upnum/zebra.conf
	        eval sed -i 's/10\.9\.0\.1/10\.8\.0\.$i/g' ./quagga_deamon/node$i/ospfd.conf
                #amend zebra.conf
	        eval sed -i 's/10\.9\.3\.1/10\.8\.$((i*2-1))\.1/g' ./quagga_deamon/node$i/zebra.conf
	        eval sed -i 's/10\.9\.2\.1/10\.8\.$((i*2-1))\.2/g' ./quagga_deamon/node$upnum/zebra.conf
	        sed -i 's/interface\ v0102/\!/g' ./quagga_deamon/node$i/ospfd.conf
                sed -i 's/interface\ v0102/\!/g' ./quagga_deamon/node$i/zebra.conf
                sed -i 's/\ ip\ address\ 10\.9\.1\.1\/24/\!/g' ./quagga_deamon/node$i/zebra.conf
                sed -i 's/interface\ v1111/\!/g' ./quagga_deamon/node$i/ospfd.conf
                sed -i 's/interface\ v1111/\!/g' ./quagga_deamon/node$i/zebra.conf
                sed -i 's/\ ip\ address\ 10\.9\.4\.1\/24/\!/g' ./quagga_deamon/node$i/zebra.conf
            fi
	fi
done
for ((i=1;i<Num;i++));do
	eval docker cp ./quagga_deamon/node$i/zebra.conf node$i:/usr/local/etc/zebra.conf
	eval docker cp ./quagga_deamon/node$i/ospfd.conf node$i:/usr/local/etc/ospfd.conf
	eval docker cp ./quagga_conf.sh node$i:/usr/local/etc/quagga_conf.sh
	eval docker exec -it node$i /bin/bash /usr/local/etc/quagga_conf.sh
done
sleep 2m
./opnode.sh
