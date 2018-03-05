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
	try:
		output = subprocess.check_output("ping -{} 1 {}".format('n' if platform.system().lower()=="windows" else 'c', ipaddr), shell=True)
	except Exception, e:
		return False
	return True

def main():
        lst = parseFile(sys.argv[1])
        for item in lst:
		print(pingTest(item))

if __name__ == "__main__":
    	main()
