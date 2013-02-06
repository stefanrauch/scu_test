#!/bin/bash


function trans_reset { 
	eb-write -p -b dev/wbm0 0x800008/4 0x0
	eb-write -p -b dev/wbm0 0x800008/4 0x1
	eb-write -p -b dev/wbm0 0x800008/4 0x0
}

while true
do

trans_reset
status=`eb-read -p dev/wbm0 0x800008/4`
printf "%2x err/done\r" $status
done

