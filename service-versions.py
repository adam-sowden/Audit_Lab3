#!/usr/bin/python

import socket, sys, os, threading

def grab_banner(ip, port):
    s = socket.socket()
    s.settimeout(10)
    isClosed = s.connect_ex((ip,port))
    if not isClosed:
        try:
            banner = s.recv(1024)
        except socket.timeout, e:
            err = e.args[0]
            if err == "timed out":
                banner = ""
        if banner != "":
            print(str(port) + ": " + banner.strip('\n'))
        else:
            print("Port " + str(port) + " is open but no service banner was found.")
    



def main():
    ip = sys.argv[1]
    print(ip + ":")
    threads = []
    for port in range(0,65535):
        grab_banner(ip, port)
    
    sys.exit(0)


if __name__ == '__main__':
    main()
