#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services
# remediation = none

ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT
