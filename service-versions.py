#!/usr/bin/python

import socket, sys, os

def grab_banner(ip, port):
    s = socket.socket()
    isOpen = s.connect_ex((ip,port))
    if not isOpen:
        banner = s.recv(1024)
        if banner != "":
            print(str(port) + ": " + banner)
        else:
            print("Port " + str(port) + " is open but no service banner was found.")
    



def main():
    ip = sys.argv[1]
    print(ip + ":")
    for port in range(0,65535):
        grab_banner(ip, port)


if __name__ == '__main__':
    main()
