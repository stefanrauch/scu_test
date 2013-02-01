#!/bin/bash

lemo_read=`eb-read dev/wbm0 0x800000/4`

eb-write dev/wbm0 0x800004/4 0x0

while true; do
	
	#set lemo 2 to input
	eb-write dev/wbm0 0x800004/4 0x2;
	# reset data reg
	eb-write dev/wbm0 0x800000/4 0x0;
	sleep 1;
	# set lemo out 1
	eb-write dev/wbm0 0x800000/4 0x1;


#	test "$lemo_read" !=  "00000003" && echo "no input on lemo 2";
	sleep 1;
	# set lemo 1 to input
	eb-write dev/wbm0 0x800004/4 0x1;
	sleep 1;
	# set lemo out 2
	eb-write dev/wbm0 0x800000/4 0x2;

	sleep 1;
done
