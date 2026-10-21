#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services,nmap-ncat
# remediation = none

nohup nc -4l 2222 &>/dev/null &
nohup nc -4ul 5353 &>/dev/null &
iptables -F
iptables -A INPUT -p tcp -m tcp --dport 2222 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 5353 -j ACCEPT
sleep 1
