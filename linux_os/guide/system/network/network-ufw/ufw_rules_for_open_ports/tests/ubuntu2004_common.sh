#!/bin/bash
# platform = Ubuntu 20.04

# Listen on TCP port 5000 on every address.
nohup python3 -c 'import socket, time
s = socket.socket()
s.bind(("0.0.0.0", 5000))
s.listen()
time.sleep(3600)' >/dev/null 2>&1 &
sleep 1
ufw --force enable
ufw allow 22/tcp
