#!/bin/bash
# platform = Ubuntu 20.04
# packages = nftables

source ubuntu2004_common.sh
nft add rule inet filter input ip saddr 127.0.0.0/8 counter drop
nft add rule inet filter input ip6 saddr ::1 counter drop
