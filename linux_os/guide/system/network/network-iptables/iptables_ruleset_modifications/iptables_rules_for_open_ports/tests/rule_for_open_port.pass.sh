#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services,nmap-ncat

nohup nc -4l 2222 &>/dev/null &
nohup nc -4ul 5353 &>/dev/null &
nohup nc -4l 127.0.0.1 2525 &>/dev/null &
iptables -F
iptables -A INPUT -p tcp -m tcp --dport 2222 -m state --state NEW -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT
sleep 1
