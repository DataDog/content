#!/bin/bash
# platform = Ubuntu 22.04,Ubuntu 24.04

DEBIAN_FRONTEND=noninteractive apt-get purge -y ufw
DEBIAN_FRONTEND=noninteractive apt-get install -y nftables
systemctl enable nftables
