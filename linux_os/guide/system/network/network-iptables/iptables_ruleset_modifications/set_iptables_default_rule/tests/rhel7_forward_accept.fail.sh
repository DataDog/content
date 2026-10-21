#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services
# remediation = none

iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT DROP
