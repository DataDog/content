#!/bin/bash
{{%- if product == "ubuntu2004" %}}
# platform = Not Applicable
{{%- endif %}}
# check = sce
# packages = nftables
# platform = multi_platform_ubuntu,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10
# variables = var_nftables_family=inet,var_nftables_table=filter

var_nftables_family="ip"
var_nftables_table="filter"

nft list tables |
while read table; do
	nft delete $table
done

nft create table "$var_nftables_family" "$var_nftables_table"
