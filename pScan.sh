#!/bin/bash
#Port scanner written in BASH

function displayIPUsage(){
echo hi
}

function displayPortUsage(){
echo "	-p
		The -p option is for listing the ports to be scanned. The ports may be in a list seperated by commas without spaces or in a range with the starting port and the ending port seperated by a dash. The ports must be an actual port (within the values of 1-65,535) and if a range is given, have the lowest port first and the highest port second.
		ex.) -p 22-445 
		ex.) -p 22,23,24,25"
}

#function for checking port status. Will display Port <portnum> is open if open.
function CheckPort(){
(echo </dev/tcp/"$IPADD"/"$PORTNUM") &>/dev/null && echo Port $PORTNUM is open 
#echo $PORTNUM
#nc $IPADD $PORTNUM < /dev/null; echo $?
}

#function to get a list of ports when a range is given as arg.
function getPortListRange(){

#get the starting and ending port numbers for the args.
STARTP=$(echo ${p} | cut -f1 -d-)
ENDP=$(echo ${p} | cut -f2 -d-)

#error checking to make sure that the ports are in valid form, exit if not.
#make sure the lowest value port is first.
if (( $STARTP > $ENDP ))
then 
	displayPortUsage
	exit 1

#make sure the first port is between 1 and 65535.
elif (("$STARTP" > 65535)) || (("$STARTP" < 1))
then
	displayPortUsage
	exit 1

#make sure the second port is between 1 and 65535
elif (( $ENDP > 65535 )) || (( $ENDP < 1 ))
then
	displayPortUsage
	exit 1
fi

#get the port list for the specified ports. 
PortList=($(seq "$STARTP" "$ENDP"))
PLlength=${#PortList[@]}
}

#function to get a list of ports when a comma seperated list or single port is given as arg.
function getPortListCom(){
PortList=(${p//,/ })
PLlength=${#PortList[@]}
}

#function to get a list of IP addresses when cider ip given as arg.
function getIPListCidr(){
echo "stub"
}

#function to get a list of IP addresses when a range is given as arg.
function getIPListRange(){
echo "stub"
}

#takes in the arguments for the program
for i in "$@"
do
case $1 in
	
	#User uses -p to specify ports.
	-p)
	p="$2"

	#checks if arg is a range.
	if [[ $p =~ ^[0-9]{1,5}\-[0-9]{1,5}$ ]]
	then
		getPortListRange $p
	
	#checks if arg is a list/single port.
	elif [[ $p =~ ^(([0-9]{1,5}\,)*[0-9]{1,5})$ ]]
	then
                getPortListCom $p

	#if neither then display port usage message.
	else
		echo "port usage message"
	fi
	shift
	shift
	;;

	#user uses -ip to specify IP addresses.
	-ip)
	ip="$2"

	#checks to see if IP addresses are in cidr
	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ ]]
	then
		echo "good ip bruh"
		#getIPListCidr $ip

	#Checks to see if the IP addresses are a range.
	elif [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\-^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
	then
        	echo "good ip bruh"
		#getIPListRange
	
	#if IP address is in neither cidr or a range display IP address usage message.
	else 
		echo "IP usage message"

	fi
	shift
	shift
	;;

	#user uses --help to get the usage message.
	--help)
	echo "usage message here"
	;;

	#if nothing is submitted as arg.
	*)
	shift
	;;
esac
done

declare -a IPList=("192.168.1.13")
IPlength=${#IPList[@]}

#chacks to see if portlist is not empty
if [[ ! -z $PortList ]]
then
	#for loop to cycle through all IPs
	for ((ip=1; ip<${IPlength}+1; ip++));
	do
		IPADD=${IPList[$ip-1]}
		echo "$IPADD"

		#for loop to cycle through all ports
		for (( prt=1; prt<${PLlength}+1; prt++ ));
		do

  			PORTNUM=${PortList[$prt-1]}
 	 		#echo "$PORTNUM"
  			CheckPort IPADD PORTNUM
			done
	done

else
echo "usage message"
fi
