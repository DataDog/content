#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services,nmap-ncat
# remediation = none

nohup nc -4l 2222 &>/dev/null &
iptables -F
iptables -A INPUT -p tcp -m tcp --dport 22220 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 12222 -j ACCEPT
sleep 1
