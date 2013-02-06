#!/bin/bash



function typewriter
{
    text="$1"
    

    for i in $(seq 0 $(expr -1 + length "${text}")) ; do
	char=${text:$i:1}        
	val=`printf "%02X\n" \'$char`
#	echo $char
#	echo $val

	$EB_WR $T_DEVx$j $DISP_ADDR$A_SUFF 0x$val
#	echo $char
	
        
    done
}

# enable uart mode
eb-write dev/wbm0 0x900000/4 0x1

HOST=`hostname` 

while true
do

T_DEVx="dev/wbm0"

A_OFFS="0x00020"
A_SUFF="/4"

DISP_ADDR="0x910000"

A_F_UTC0="30C"
A_F_UTC1="308"
A_F_CYC="304"

EB_WR="eb-write -p -f"
EB_RD="eb-read -p -f"


#echo "Trigger all"

UTC0=0x`$EB_RD $T_DEVx$j $A_OFFS$A_F_UTC0$A_SUFF`
UTC1=0x`$EB_RD $T_DEVx$j $A_OFFS$A_F_UTC1$A_SUFF`
CYC=0x`$EB_RD $T_DEVx$j $A_OFFS$A_F_CYC$A_SUFF`
NS=$((CYC*8))
S_OVER=$((NS/1000000000))
UTC=$((UTC0*256 + UTC1 + S_OVER))
NS=$((NS-S_OVER*1000000000))
CYC=$((NS/8))

UTCASCII=`date +"%Y-%m-%d %H:%M:%S" -d @$UTC`
NSASCII=`printf ".%09d\n" $NS`
UTCASCIIDATE=`echo $UTCASCII | cut -d \  -f 1`
UTCASCIITIME=`echo $UTCASCII | cut -d \  -f 2`


  
$EB_WR $T_DEVx$j $DISP_ADDR$A_SUFF 0x0C
typewriter $HOST 
$EB_WR $T_DEVx$j $DISP_ADDR$A_SUFF 0x0A
$EB_WR $T_DEVx$j $DISP_ADDR$A_SUFF 0x0A
typewriter $UTCASCIIDATE
$EB_WR $T_DEVx$j $DISP_ADDR$A_SUFF 0x0A
typewriter $UTCASCIITIME
#$EB_WR $T_DEVx$j $DISP_ADDR$A_SUFF 0x0A
#typewriter $NSASCII

sleep 0.5
done
