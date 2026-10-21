#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services

iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 127.0.0.0/8 -j DROP
iptables -A OUTPUT -o lo -j ACCEPT
