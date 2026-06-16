#!/bin/bash
Num=97
for ((i=1;i<Num;i++));do
	eval docker stop node$i
	eval docker rm -f node$i
done
