#!/bin/bash

usage_string="usage: ./ping_sweep.sh [127.0.0.1-127.0.0.255 | 127.0.0.1/24]"

if [[ $# -eq 0 || $# -gt 1 ]]
then
    echo $usage_string
    exit 1
fi

# Function to handle address range given in 10.10.1.1-10.10.2.50 format
dash_fmt() {
    bottom_range=$(echo $address_range | cut -d"-" -f 1)
    top_range=$(echo $address_range | cut -d"-" -f 2)

    bot_first=$(echo $bottom_range | cut -d"." -f 1)
    bot_second=$(echo $bottom_range | cut -d"." -f 2)
    bot_third=$(echo $bottom_range | cut -d"." -f 3)
    bot_fourth=$(echo $bottom_range | cut -d"." -f 4)

    top_first=$(echo $top_range | cut -d"." -f 1)
    top_second=$(echo $top_range | cut -d"." -f 2)
    top_third=$(echo $top_range | cut -d"." -f 3)
    top_fourth=$(echo $top_range | cut -d"." -f 4)

   while true
   do
       while true
       do
           while true
           do
               while true
               do
                   ping_cmd=`eval "ping -c 1 $bot_first.$bot_second.$bot_third.$bot_fourth | grep from"`
                   if [ "$ping_cmd" != "" ]
                   then
                       echo "Host $bot_first.$bot_second.$bot_third.$bot_fourth is up"
                   fi
                   if [ $bot_fourth == $top_fourth ] || [ $bot_fourth == 256 ]
                   then
                       break
                   else
                       bot_fourth=$((bot_fourth+1))
                   fi
               done
               if [ $bot_third == $top_third ] || [ $bot_third == 256 ]
               then
                   break
               else
                   bot_third=$((bot_third+1))
                   bot_fourth=0
               fi
           done
           if [ $bot_second == $top_second ] || [ $bot_second == 256 ]
           then
               break
           else
               bot_second=$((bot_second+1))
               bot_third=0
               bot_fourth=0
           fi
       done
       if [ $bot_first == $top_first ] || [ $bot_first == 256 ]
       then
           break
       else
           bot_first=$((bot_first+1))
           bot_second=0
           bot_third=0
           bot_fourth=0
       fi
   done

    exit 0
}

# Function to handle address range given in 10.10.0.0/16 format
cidr_fmt() {
    echo "Cidr format of address"
    echo $address_range

    exit 0
}

# address range provided via cmdline args
address_range=$1

# length of the arg string
length=${#address_range}

for (( i=0; i<$length; i++ ));
do
    char=${address_range:$i:1}
    if [ $char == "-" ]
    then
        # if the range provided has a dash in it parse using dash_fmt()
        dash_fmt
    elif [ $char == "/" ]
    then
        # if the range provided has a forward slash in it parse using cidr_fmt()
        cidr_fmt
    fi
done

