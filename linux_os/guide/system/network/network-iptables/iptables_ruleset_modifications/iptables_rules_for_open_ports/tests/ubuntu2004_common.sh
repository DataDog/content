#!/bin/bash
# platform = Ubuntu 20.04

DEBIAN_FRONTEND=noninteractive apt-get purge -y ufw nftables
# Listen on TCP port 5000 on every address.
nohup python3 -c 'import socket, time
s = socket.socket()
s.bind(("0.0.0.0", 5000))
s.listen()
time.sleep(3600)' >/dev/null 2>&1 &
sleep 1
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
