#!/bin/bash
# platform = Ubuntu 20.04
# packages = ufw,nftables

# CIS 4.2.2: nftables must not be in use on a host that uses ufw.
DEBIAN_FRONTEND=noninteractive apt-get purge -y iptables-persistent
sed -i 's/^ENABLED=.*/ENABLED=yes/' /etc/ufw/ufw.conf
systemctl unmask ufw.service
systemctl enable ufw.service
systemctl unmask nftables.service
systemctl enable nftables.service
