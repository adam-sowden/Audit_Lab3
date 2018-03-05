import os
import sys
import subprocess, platform

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
	return output

def main():
        lst = parseFile(sys.argv[1])
       	final = [] # IPDown = 0, Win = 1,  Unix = 2, BSD = 3
	for item in lst:
		output = pingTest(item)
		if (output != False):
			str = output.split(' ')[10][4:]
			str = int(str)
			if (str == 64):
				final.append(2)
			if (str == 255 ):
				final.append(3)
			if (str == 128 ):
				final.append(1)
		else :
			final.append(0)
	for i in range(0,len(final)):
		if (final[i] == 0):
			print('Ip address: ' + lst[i] + ' is down' + '\n')
			continue
		if (final[i] == 1):
			print('Ip address: ' + lst[i] + ' is up. OS: Windows \n')
			continue
		else:
			print('Ip address: ' + lst[i] + ' is up. OS: Unix \n')
			continue
	return 0

if __name__ == "__main__":
    	main()
