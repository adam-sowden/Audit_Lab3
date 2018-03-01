SYNOPSIS:
pScan.sh is a port scanning tool written in bash and requires no external tools/dependencies other than access to /dev/tcp/ and /dev/null on a linux machine. The tool list the IP addresses that are up in the given range and then gives a list of the port number that are open on each of them.

SAMPLE USAGE:
./pScan.sh -ip 192.168.0.0/24 -p 22-445

This will scan the entire 192.168.0.0 network and then list the ports in the 22-445 range that are open for each host that is up in the IP range.

INSTALLATION:
Download and unzip or clone the script from https://github.com/adam-sowden/Audit_Lab3.git
Then change into the directory where the script is located and run the script.
