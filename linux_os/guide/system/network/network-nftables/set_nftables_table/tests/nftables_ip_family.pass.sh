#!/bin/bash
# check = sce
# packages = nftables
# platform = Red Hat Enterprise Linux 7
# variables = var_nftables_family=inet,var_nftables_table=filter

nft list tables |
while read table; do
	nft delete $table
done

nft create table ip filter
