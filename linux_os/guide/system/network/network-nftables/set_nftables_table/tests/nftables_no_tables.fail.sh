#!/bin/bash
# check = sce
# packages = nftables
# variables = var_nftables_family=inet,var_nftables_table=filter

nft list tables |
while read table; do
	nft delete $table
done
