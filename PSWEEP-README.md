Usage:  ./ping-sweep.sh -ip 192.168.0.0/24
        ./ping-sweep.sh -ip 192.168.0.0-192.168.0.256


ping-sweep.sh takes an ip address range as an argument in either cidr format or
dash format (192.168.1.0-192.168.1.256). Each address in the range is pinged
once and a message prints out if the host is up.
