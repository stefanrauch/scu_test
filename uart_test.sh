#!/bin/bash

if [ "$1" == "COM1" ]; then
	status_reg=0x20500
	baud_reg=0x20504
	tx_reg=0x20508
	rx_reg=0x2050c
elif [ "$1" == "COM2" ]; then
	status_reg=0x800100
	baud_reg=0x800104
	tx_reg=0x800108
	rx_reg=0x80010c
else
	echo "Usage: uart_test COM1/COM2"
	exit
fi


printf "Base address: 0x%x\n" $status_reg
# hold lm32 in reset
eb-write dev/wbm0 0x20400/4 0x1deadbee

# init baudrate to 115200
eb-write dev/wbm0 $baud_reg/4 0x3c6

for data in {0..255}
do
	eb-write dev/wbm0 $tx_reg/4 $data
	status_read=0x`eb-read -b -f dev/wbm0 $status_reg/4`
	# testing with bitmask for bit 2
	let foo=status_read\&2
	# print with conversion to unicode
	if [ $foo -gt 0 ]; then
		read_val=0x`eb-read -b -f dev/wbm0 $rx_reg/4`
		let read_val=read_val\&255
		if [ $data != $read_val ]; then
			echo "UART error"
			printf "%x %x\n" $data $read_val
			exit			
		fi
		printf  "%x %x\r" $data $read_val
	fi
done

if [ "$read_val" == "255" ]; then
	echo "UART test done."
else
	echo "UART test failed."
fi

# release lm32
eb-write dev/wbm0 0x20400/4 0x0deadbee
