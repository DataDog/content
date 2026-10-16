#!/bin/bash
# platform = Ubuntu 22.04,Ubuntu 24.04
# variables = var_network_filtering_service=ufw

# No firewall utility is in use, so the ufw guidance applies.
DEBIAN_FRONTEND=noninteractive apt-get purge -y ufw iptables-persistent
if dpkg -s nftables >/dev/null 2>&1; then
    systemctl disable nftables
fi
