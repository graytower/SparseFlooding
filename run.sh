#!/bin/bash 

./build_net.sh
./set_link.sh
echo "sleep 2min"
sleep 2m
echo "getting results!"
./get_result.sh
echo "delete networks"
./del_net.sh

