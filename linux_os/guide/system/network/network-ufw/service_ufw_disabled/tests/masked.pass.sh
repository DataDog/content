#!/bin/bash
# platform = multi_platform_ubuntu
# packages = ufw,iptables-persistent

sed -i 's/^ENABLED=.*/ENABLED=no/' /etc/ufw/ufw.conf
systemctl mask ufw.service
