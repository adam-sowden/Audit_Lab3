#!/bin/bash

#display the useage
function displayUsage(){
echo "ping_sweep
Usage: ping_sweep -ip <IP Range>

-ip <IP Range>
The -ip option is for listing the range of IP addresses that you wish to conduct a ping sweep on. The range may be in cidr notation or an IP range with the start of the range first and the end of the range second seperated by a dash. The IP addresses must be valid for this utility to work.
        ex.) -ip 192.168.1.0/24 
        ex.) -ip 192.168.1.0-192.168.1.50"
}

#Display usage when the IP address option is not valid.
function displayIPUsage(){
echo "-ip <IP Range>
The -ip option is for listing the range of IP addresses that you wish to conduct a ping sweep on. The range may be in cidr notation or an IP range with the start of the range first and the end of the range second seperated by a dash. The IP addresses must be valid for this utility to work.
        ex.) -ip 192.168.1.0/24 
        ex.) -ip 192.168.1.0-192.168.1.50"
}

#helper function for getiing ip ranges
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

#takes in the arguments for the program
for i in "$@"
do
case $1 in

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
echo IPs UP:
echo 

#for loop to cycle through all IPs
for ((ip=1; ip<${IPlength}+1; ip++));
do
        IPADD=${IPArray[$ip-1]}
	checkIP IPADD

done
echo DONE!



#dash_fmt() {
  #  echo "Dash format of address"
 #   echo $address_range
#}

# Function to handle address range given in 10.10.0.0/16 format
#cidr_fmt() {
  #  echo "Cidr format of address"
 #   echo $address_range
#}

# address range provided via cmdline args
#address_range=$1

# length of the arg string
#length=${#address_range}

#for (( i=0; i<$length; i++ ));
#do
    #char=${address_range:$i:1}
    #if [ $char == "-" ]
   # then
        # if the range provided has a dash in it parse using dash_fmt()
     #   dash_fmt
    #elif [ $char == "/" ]
   # then
        # if the range provided has a forward slash in it parse using cidr_fmt()
  #      cidr_fmt
 #   fi
#done
