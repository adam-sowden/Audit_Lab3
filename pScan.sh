#!/bin/bash
#Port scanner written in BASH

PLIST="1..23"
IPADD="127.0.0.1"
#STARTP="1"
#ENDP="650"
TESTLIST={1,2,22,631}

#function for checking port status
function CheckPort(){
(echo > /dev/tcp/"$IPADD"/"$PORTNUM")>& /dev/null && echo "Port "$PORTNUM" seems to be open"

}

#function for checking range of ports
function PortRange(){
for PORTNUM in $(seq "$STARTP" "$ENDP"); do
        CheckPort IPADD PORTNUM
done
}


STARTP=$(echo $1 | cut -f1 -d-)
ENDP=$(echo $1 | cut -f2 -d-)

echo "$STARTP"
echo "$ENDP"

#for PORTNUM in {$1}; do 
#echo $PORTNUM
#CheckPort IPADD PORTNUM
#done 

PortRange STARTP ENDP

