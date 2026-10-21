#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# No firewall utility is in use, so the firewalld guidance applies.
yum -y remove firewalld iptables-services
if rpm -q nftables >/dev/null 2>&1; then
    systemctl disable nftables
fi
