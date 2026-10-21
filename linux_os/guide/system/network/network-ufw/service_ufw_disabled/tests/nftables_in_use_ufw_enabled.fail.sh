#!/bin/bash
# platform = multi_platform_ubuntu
# packages = ufw,nftables

# nftables is the firewall in use, without iptables-persistent, so ufw
# must be removed or masked.
DEBIAN_FRONTEND=noninteractive apt-get purge -y iptables-persistent
systemctl unmask nftables.service
systemctl enable nftables.service
systemctl unmask ufw.service
systemctl enable ufw.service
