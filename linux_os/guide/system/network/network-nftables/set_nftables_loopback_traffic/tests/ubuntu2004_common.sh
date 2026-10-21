#!/bin/bash
# platform = Ubuntu 20.04

# nftables is in use, so the remediation runs.
systemctl enable nftables.service
nft flush ruleset
nft add table inet filter
nft add chain inet filter input '{ type filter hook input priority 0; policy accept; }'
nft add rule inet filter input iif lo accept
