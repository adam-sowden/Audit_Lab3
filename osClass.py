import os
import sys

def parseFile( file) :
        file = open ( file)
        lst = []
        for line in file :
                line = line.strip()
                lst.append(line)
        return lst



def main():
        lst = parseFile(sys.argv[1])
        print(lst)

if __name__ == "__main__":
    	main()
	main(sys.argv)
