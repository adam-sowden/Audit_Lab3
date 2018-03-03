#!/bin/bash
#Port scanner written in BASH

#display the usage.
function displayUsage(){
echo "pScan
Usage: pScan -ip <IP Range> -p <Port Range>

-ip <IP Range>
The -ip option is for listing the range of IP addresses that you wish to conduct a portscan on. The range may be in cidr notation or an IP range with the start of the range first and the end of the range second seperated by a dash. The IP addresses must be valid for this utility to work.
        ex.) -ip 192.168.1.0/24 
        ex.) -ip 192.168.1.0-192.168.1.50

-p <Port Range> 	
The -p option is for listing the ports to be scanned. The ports may be in a list seperated by commas without spaces or in a range with the starting port and the ending port seperated by a dash. The ports must be an actual port (within the values of 1-65,535) and if a range is given, have the lowest port first and the highest port second.
                ex.) -p 22-445 
                ex.) -p 22,23,24,25"

}

#Display usage when the IP address option is not valid.
function displayIPUsage(){
echo "-ip <IP Range>
The -ip option is for listing the range of IP addresses that you wish to conduct a portscan on. The range may be in cidr notation or an IP range with the start of the range first and the end of the range second seperated by a dash. The IP addresses must be valid for this utility to work.
	ex.) -ip 192.168.1.0/24 
	ex.) -ip 192.168.1.0-192.168.1.50"
}

#Display usage when the port option is not valid.
function displayPortUsage(){
echo "-p <Port Range>
The -p option is for listing the ports to be scanned. The ports may be in a list seperated by commas without spaces or in a range with the starting port and the ending port seperated by a dash. The ports must be an actual port (within the values of 1-65,535) and if a range is given, have the lowest port first and the highest port second.
		ex.) -p 22-445 
		ex.) -p 22,23,24,25"
}

#helper function for getiing ip range
function atoi()
{
#Returns the integer representation of an IP arg, passed in ascii dotted-decimal notation (x.x.x.x)
IP=$1; IPNUM=0
for (( i=0 ; i<4 ; ++i )); 
do
((IPNUM+=${IP%%.*}*$((256**$((3-${i}))))))
IP=${IP#*.}
done
echo $IPNUM 
}

#helper function for getting ip ranges
function itoa()
{
#returns the dotted-decimal ascii form of an IP arg passed in integer format
echo -n $(($(($(($((${1}/256))/256))/256))%256)).
echo -n $(($(($((${1}/256))/256))%256)).
echo -n $(($((${1}/256))%256)).
echo $((${1}%256)) 
}

#function for checking port status. Will display Port <portnum> is open if open.
function CheckPort(){
(echo </dev/tcp/"$IPADD"/"$PORTNUM") &>/dev/null && echo "$PORTNUM (OPEN)" && cnt=$cnt+1
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

#get the cider number for the IP range.
CIDR=$(echo ${ip} | cut -f2 -d/)

#from the cidr number check to see if its in the correct format and get a list based on number.
case $CIDR in

	#get the list of IPs on a /24 network.
	24)
	NETWORK=$(echo ${ip} | cut -f 1-3 -d.)
	IPListT=$(echo ${NETWORK}.{0..255})
	IPList=$(echo ${IPListT} | cut -f 2-255 -d' ')
	#make an array for the list of IPs
	IFS=' ' read -r -a IPArray <<< "$IPList"
	IPlength=${#IPArray[@]}
	;;

	#get a list of IPs on a /16 network.
	16)
	NETWORK=$(echo ${ip} | cut -f 1-2 -d.)
        IPListT=$(echo ${NETWORK}.{0..255}.{0..255})
	IPList=$(echo ${IPListT} | cut -f 2-65535 -d' ') 
	#make an array for the list of IPs
	IFS=' ' read -r -a IPArray <<< "$IPList"
	IPlength=${#IPArray[@]}
	;;

	#get the list of IPs on a /8 network
	8)
	NETWORK=$(echo ${ip} | cut -f1 -d.)
        IPList=$(echo ${NETWORK}.{0..255}.{0.255}.{0..255})
	IPList=$(echo ${IPListT} | cut -f 2-16777215 -d' ')
	#make an array for the list of IPs
	IFS=' ' read -r -a IPArray <<< "$IPList"
	IPlength=${#IPArray[@]}
	;;

	#if the cider is not /24, /16, or /8. 
	*)
		displayIPUsage
                exit 1
	;;
esac
}

#function to get a list of IP addresses when a range is given as arg.
function getIPListRange(){

StartIP=$(echo ${ip} | cut -f1 -d-)
EndIP=$(echo ${ip} | cut -f2 -d-)

sIP=`atoi "${StartIP}"`
eIP=`atoi "${EndIP}"`

IPList=''

#if the first IP is less than the second
if [ "$sIP" -le "$eIP" ]     
        then

	#while loop to cycle through the IPs
        while [ "${sIP}" -le "${eIP}" ]; do
        nIP=`itoa "${sIP}"`
	IPList="$IPList $nIP"
        let sIP=sIP+1
        done
	IFS=' ' read -r -a IPArray <<< "$IPList"
        IPlength=${#IPArray[@]}

#if the starting IP is greater than the ending IP   	
else
	displayIPUsage
        exit 1

fi
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
		displayPortUsage
        	exit 1
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
		getIPListCidr $ip

	#Checks to see if the IP addresses are a range.
	elif [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
	then
		getIPListRange $ip
	
	#if IP address is in neither cidr or a range display IP address usage message.
	else 
		displayIPUsage
		exit 1
	fi
	shift
	shift
	;;

	#user uses --help to get the usage message.
	--help)
	displayUsage 
	exit 1
	;;

	#if nothing is submitted as arg.
	*)
	shift
	;;
esac
done

echo
echo SCANNING:
echo

#for loop to cycle through all IPs
for ((ip=1; ip<${IPlength}+1; ip++));
do
	IPADD=${IPArray[$ip-1]}
	#echo "$IPADD"
	cnt=0

	#for loop to cycle through all ports
	for (( prt=1; prt<${PLlength}+1; prt++ ));
	do

  		PORTNUM=${PortList[$prt-1]}
		if (( $PORTNUM < 1 )) || (( $PORTNUM > 65535 ))
		then
			displayPortUsage
        		exit 1
		fi
  		CheckPort IPADD PORTNUM
	done
	if (( $cnt > 0 ))
                then
                echo "Are the ports open on $IPADD"
		echo
        fi
done
echo DONE!

