#!/bin/bash

# init baudrate to 115200
eb-write dev/wbm0 0x800104/4 0x3c6
data=0;

while true; do
	eb-write dev/wbm0 0x800108/4 $data
	status_read=0x`eb-read -b -f dev/wbm0 0x800100/4`
	# testing with bitmask for bit 2
	let foo=status_read\&2
	# print with conversion to unicode
	if [ $foo -gt 0 ]; then
		read_val=0x`eb-read -b -f dev/wbm0 0x80010c/4`
		let read_val=read_val\&255
		if [ $data != $read_val ]; then
			echo "UART error"
			echo $data
			echo $read_val
			exit			
		fi
		printf  "%x %x\n" $data $read_val
	fi
	if [ $data = 255 ]; then
		let data=0		
	else
		let data++
	fi
done

