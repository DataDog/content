#!/bin/bash
# platform = Ubuntu 20.04
# packages = nftables
# variables = var_nftables_master_config_file=/etc/nftables.conf

# The nftables.conf of the package defines its table with no include.
# nftables is in use, so the remediation runs.
systemctl enable nftables.service
nft -f /etc/nftables.conf
