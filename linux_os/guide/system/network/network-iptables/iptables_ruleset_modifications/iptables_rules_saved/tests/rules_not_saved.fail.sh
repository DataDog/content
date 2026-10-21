#!/bin/bash
# packages = iptables-services
# remediation = none

iptables-save > /etc/sysconfig/iptables
iptables -A INPUT -p tcp -m tcp --dport 2222 -j ACCEPT
