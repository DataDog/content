#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services,nmap-ncat

nohup nc -4l 2222 &>/dev/null &
iptables -F
iptables -A INPUT -p tcp -m multiport --dports 22,2222,8080 -j ACCEPT
sleep 1
