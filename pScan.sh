#!/bin/bash
#Port scanner written in BASH

IPADD="127.0.0.1"

#function for checking port status
function CheckPort(){
(echo > /dev/tcp/"$IPADD"/"$PORTNUM")>& /dev/null && echo "Port "$PORTNUM" seems to be open"

}


STARTP=$(echo $1 | cut -f1 -d-)
ENDP=$(echo $1 | cut -f2 -d-)
declare -a P2BS=($(seq "$STARTP" "$ENDP"))
arraylength=${#P2BS[@]}

for (( i=1; i<${arraylength}+1; i++ ));
do
  PORTNUM=${P2BS[$i-1]}
  CheckPort IPADD PORTNUM
done

