SYNOPSIS:
ping_sweep.sh is a ping sweeping tool written in bash and requires no external tools/dependencies other than the use of the ping tool on linux. The tool will go through the range of IPs that it's given and then output if they are up or not.

SAMPLE USAGE:
./ping_sweep.sh -ip 192.168.0.0/24

This will scan the entire 192.168.0.0 network and then list wich devices respond to a ping in the IP range.

INSTALLATION:
Download and unzip or clone the script from https://github.com/adam-sowden/Audit_Lab3.git
Then change into the directory where the script is located and run the script.

