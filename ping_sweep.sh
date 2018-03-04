#!/bin/bash
#ping sweeping utility writen in BASH

#display the useage for the --help option
function displayUsage(){
echo "ping_sweep
Usage: ping_sweep -ip <IP Range>

-ip <IP Range>
The -ip option is for listing the range of IP addresses that you wish to conduct a ping sweep on. The range may be in cidr notation or an IP range with the start of the range first and the end of the range second seperated by a dash. The IP addresses must be valid for this utility to work.
        ex.) -ip 192.168.1.0/24 
        ex.) -ip 192.168.1.0-192.168.1.50"
}

#display usage when the IP address option is not valid.
function displayIPUsage(){
echo "-ip <IP Range>
The -ip option is for listing the range of IP addresses that you wish to conduct a ping sweep on. The range may be in cidr notation or an IP range with the start of the range first and the end of the range second seperated by a dash. The IP addresses must be valid for this utility to work.
        ex.) -ip 192.168.1.0/24 
        ex.) -ip 192.168.1.0-192.168.1.50"
}

#helper function for getiing ip ranges
function atoi(){
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
function itoa(){
#returns the dotted-decimal ascii form of an IP arg passed in integer format
echo -n $(($(($(($((${1}/256))/256))/256))%256)).
echo -n $(($(($((${1}/256))/256))%256)).
echo -n $(($((${1}/256))%256)).
echo $((${1}%256)) 
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

#get the start and end of the range.
StartIP=$(echo ${ip} | cut -f1 -d-)
EndIP=$(echo ${ip} | cut -f2 -d-)

#convert start and end into integers.
sIP=`atoi "${StartIP}"`
eIP=`atoi "${EndIP}"`

#empty list for putting the IPs in 
IPList=''

#if the first IP is less than the second
if [ "$sIP" -le "$eIP" ]
        then

        #while loop to cycle through the IPs
        while [ "${sIP}" -le "${eIP}" ]; do

	#convert back to ascii
        nIP=`itoa "${sIP}"`

	#add the IP to the list
        IPList="$IPList $nIP"

	#increment the IP
        let sIP=sIP+1
        done

	#use the list to create an array
        IFS=' ' read -r -a IPArray <<< "$IPList"

	#get the length of the array
        IPlength=${#IPArray[@]}

#if the starting IP is greater than the ending IP       
else
	#display the usage for -ip
        displayIPUsage
        exit 1
fi
}

#send a ping to the IP and see if it is up or down.
function checkIP(){
#ping the IP address
ping -c1 -W1 $IPADD &>/dev/null 
status=$( echo $?)
if (($status == 0));
then
	echo "$IPADD is up!"
fi
}

###MAIN###
###############################################################################
#takes in the arguments for the program and perform the correct functions on 
#them based on the format of the inputs.
#check to see if there is args, if not exit and display usage.
if [ -z "$1" ];
then 
	#display usage and exit.
        displayUsage
        exit 1
fi

#for loop to grab all arguments.
for i in "$@"
do
case $1 in

#user uses -ip to specify IP addresses.
        -ip)
        ip="$2"

        #checks to see if IP addresses are in cidr
        if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ ]]
        then
		#call the getIPListCidr function.
                getIPListCidr $ip

        #Checks to see if the IP addresses are a range.
        elif [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
        then
		#call the getIPListRange function.
                getIPListRange $ip

        #if IP address is in neither cidr or a range display IP address usage message.
        else
		#display the usage for -ip
                displayIPUsage
                exit 1
        fi
        ;;

        #user uses --help to get the usage message.
        --help)
	#display usage and exit.
        displayUsage
        exit 1
        ;;

        #if any other case.
        *)
	#display usage and exit.
	displayUsage
        exit 1
        ;;
esac
done

#formatting output.
echo 
echo IPs UP:
echo 

#for loop to cycle through all IPs.
for ((ip=1; ip<${IPlength}+1; ip++));
do
	#get the IP address from the array of IPs.
        IPADD=${IPArray[$ip-1]}

	#call the checkIP function to see if it is up or not.
	checkIP IPADD

done

#finished sweeping IPs.
echo DONE!

#exit script.
exit 1
