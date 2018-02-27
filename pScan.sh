#!/bin/bash
#Port scanner written in BASH

IPADD="127.0.0.1"

#function for checking port status. Will display Port <portnum> is open if open.
function CheckPort(){
(echo > /dev/tcp/"$IPADD"/"$PORTNUM")>& /dev/null && echo "Port "$PORTNUM" is open"

}

STARTP=$(echo $1 | cut -f1 -d-)
ENDP=$(echo $1 | cut -f2 -d-)
declare -a PortList=($(seq "$STARTP" "$ENDP"))
PLlength=${#PortList[@]}

for (( i=1; i<${PLlength}+1; i++ ));
do
  PORTNUM=${PortList[$i-1]}
  CheckPort IPADD PORTNUM
done

