#!/bin/bash
#Port scanner written in BASH

#function for checking port status. Will display Port <portnum> is open if open.
function CheckPort(){
(echo > /dev/tcp/"$IPADD"/"$PORTNUM")>& /dev/null && echo "Port "$PORTNUM" is open"
}

#function to get a list of ports when a range is put for input (takes $1 for arg))
function getPortListRange(){
STARTP=$(echo ${pR} | cut -f1 -d-)
ENDP=$(echo ${pR} | cut -f2 -d-)
PortList=($(seq "$STARTP" "$ENDP"))
PLlength=${#PortList[@]}
}

#function to get a list of ports when a comma seperated list is given as input
function getPortListCom(){
PortList=(${pL//,/ })
PLlength=${#PortList[@]}
}

#function to get a list of IP addresses when cider id given
function getIPListCidr(){
#stub
}

function getIPListRange(){
STARTIP=$(echo ${ipR} | cut -f1 -d-)
ENDIP=$(echo ${ipR} | cut -f2 -d-)
}


#takes in the arguments for the program
for i in "$@"
do
case $1 in
	-pL)
	pL="$2"
	getPortListCom $pL
	shift
	shift
	;;
	-pR)
	pR="$2"
	getPortListRange $pR
	shift
	shift
	;;
	-ipR)
	shift
	shift
	;;
	-ipC)
	ipC="$2"
	getIPListCom $ipC
	shift
	shift
	;;
	--help)
	echo "usage message here"
	;;

esac
done

#meat of the script that actually scans ports 
for ((ip=1; ip<${IPlength}+1; ip++));
do
IPADD=${IPList[$ip-1]}
echo "$IPADD"
	for (( prt=1; prt<${PLlength}+1; prt++ ));
	do

  	PORTNUM=${PortList[$prt-1]}
 	 #echo "$PORTNUM"
  	CheckPort IPADD PORTNUM
	done
done
