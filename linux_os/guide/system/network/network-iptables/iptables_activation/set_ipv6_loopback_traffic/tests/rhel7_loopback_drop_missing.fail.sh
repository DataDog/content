#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services
# remediation = none

ip6tables -F
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT
