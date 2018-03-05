import os
import sys
import platform

def parseFile( file ):
        file = open ( file)
        lst = []
        for line in file :
                line = line.strip()
                lst.append(line)
        return lst

def pingTest( ipaddr ):
    hostname = ipaddr
    response = os.system("ping -c 1 " + hostname)
    # and then check the response...
    if response == 0:
        pingstatus = True
    else:
        pingstatus = False
    return pingstatus


def main():
        lst = parseFile(sys.argv[1])
        for item in lst:
		print(pingTest(item))

if __name__ == "__main__":
    	main()
	main(sys.argv)
