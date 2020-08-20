#!/usr/bin/env python
# -*- coding: utf-8 -*-

import socket
while 1:
    sock = socket.socket()
    message= str(input())
    addr= "192.168.0.102"
    addr1="127.0.0.1"
    sock.connect((addr , 5566))
    sock.send(bytes(message, 'ascii'))

    data = sock.recv(1024)
    print(data)
sock.close()