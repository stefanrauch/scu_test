#!/bin/bash

# init baudrate to 115200
eb-write dev/wbm0 0x800104/4 0x3c6

while true; do
	status_read=0x`eb-read dev/wbm0 0x800100/4`
	# testing with bitmask for bit 2
	let foo=status_read\&2
	# print with conversion to unicode
	test $foo -gt 0 && printf \\U`eb-read dev/wbm0 0x80010c/4`
done

