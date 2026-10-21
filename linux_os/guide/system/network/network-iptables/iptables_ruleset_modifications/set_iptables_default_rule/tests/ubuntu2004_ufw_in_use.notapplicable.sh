#!/bin/bash
# platform = Ubuntu 20.04
# packages = ufw

DEBIAN_FRONTEND=noninteractive apt-get purge -y iptables-persistent nftables
sed -i 's/^ENABLED=.*/ENABLED=yes/' /etc/ufw/ufw.conf
systemctl unmask ufw.service
systemctl enable ufw.service
