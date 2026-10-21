#!/bin/bash
# platform = Ubuntu 20.04
# packages = nftables

source ubuntu2004_common.sh
nft add rule inet filter input ip saddr 10.0.0.0/8 accept
nft add rule inet filter input ip6 saddr fe80::/10 accept
