#!/bin/bash
# platform = Ubuntu 20.04
# packages = iptables,iptables-persistent
# remediation = none

source ubuntu2004_common.sh
iptables -A INPUT -p tcp --dport 50000 -m state --state NEW -j ACCEPT
