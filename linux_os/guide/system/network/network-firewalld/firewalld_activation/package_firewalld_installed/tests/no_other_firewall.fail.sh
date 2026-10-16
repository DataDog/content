#!/bin/bash
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,AlmaLinux OS 9

# No firewall utility is in use, so the firewalld guidance applies.
dnf -y remove firewalld iptables-services
if rpm -q nftables >/dev/null 2>&1; then
    systemctl disable nftables
fi
