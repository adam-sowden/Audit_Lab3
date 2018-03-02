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
    echo $bottom_range
    echo $top_range

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

