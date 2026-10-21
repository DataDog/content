#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = nftables

nft flush ruleset
nft add table inet filter
nft add chain inet filter input '{ type filter hook input priority 0; policy accept; }'
nft add rule inet filter input iif lo accept
nft add rule inet filter input ip saddr 127.0.0.0/8 counter drop
