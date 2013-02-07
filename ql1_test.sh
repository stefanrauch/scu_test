#!/bin/bash


function trans_reset { 
	eb-write -p -b dev/wbm0 0x800008/4 0x0
	eb-write -p -b dev/wbm0 0x800008/4 0x1
	eb-write -p -b dev/wbm0 0x800008/4 0x0
}

done_4_=0
done_5_=0
done_6_=0
done_7_=0
err_4_=0
err_5_=0
err_6_=0
err_7_=0

printf "QL1 transceiver test\n"
printf "DONE GXB 4\tDONE GXB 5\tDONE GXB 6\tDONE GXB 7\tERR GXB 4\tERR GXB 5\tERR GXB 6\tERR GXB 7\n"

while true
do

trans_reset
status=0x`eb-read -p dev/wbm0 0x800008/4`
let done_ql1_4=status\&1
let done_ql1_5=status\&2
let done_ql1_6=status\&4
let done_ql1_7=status\&8
let err_ql1_4=status\&16
let err_ql1_5=status\&32
let err_ql1_6=status\&64
let err_ql1_7=status\&128

test $done_ql1_4 -gt 0 && let done_4_++
test $done_ql1_5 -gt 0 && let done_5_++
test $done_ql1_6 -gt 0 && let done_6_++
test $done_ql1_7 -gt 0 && let done_7_++
test $err_ql1_4 -gt 0 && let err_4_++
test $err_ql1_5 -gt 0 && let err_5_++
test $err_ql1_6 -gt 0 && let err_6_++
test $err_ql1_7 -gt 0 && let err_7_++
printf "%d\t\t%d\t\t%d\t\t%d\t\t%d\t\t%d\t\t%d\t\t%d\r" $done_4_ $done_5_ $done_6_ $done_7_ $err_4_ $err_5_ $err_6_ $err_7_
done

