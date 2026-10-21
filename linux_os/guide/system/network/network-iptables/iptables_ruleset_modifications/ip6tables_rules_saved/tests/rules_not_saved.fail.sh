#!/bin/bash
# packages = iptables-services
# remediation = none

ip6tables-save > /etc/sysconfig/ip6tables
ip6tables -A INPUT -p tcp -m tcp --dport 2222 -j ACCEPT
