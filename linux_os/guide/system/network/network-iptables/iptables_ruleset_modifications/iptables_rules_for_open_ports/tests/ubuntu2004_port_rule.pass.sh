#!/bin/bash
# platform = Ubuntu 20.04
# packages = iptables,iptables-persistent

source ubuntu2004_common.sh
iptables -A INPUT -p tcp --dport 5000 -m state --state NEW -j ACCEPT
