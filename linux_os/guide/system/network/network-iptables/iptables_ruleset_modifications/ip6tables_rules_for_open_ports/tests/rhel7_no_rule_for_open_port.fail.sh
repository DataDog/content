#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services,nmap-ncat
# remediation = none

nohup nc -6ul 5353 &>/dev/null &
ip6tables -F
ip6tables -A INPUT -p tcp -m tcp --dport 5353 -j ACCEPT
sleep 1
