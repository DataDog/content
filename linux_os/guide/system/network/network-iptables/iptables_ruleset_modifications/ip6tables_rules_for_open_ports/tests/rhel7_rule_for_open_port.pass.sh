#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services,nmap-ncat

nohup nc -6l 2222 &>/dev/null &
nohup nc -6l ::1 2525 &>/dev/null &
ip6tables -F
ip6tables -A INPUT -p tcp -m multiport --dports 22,2222 -j ACCEPT
sleep 1
