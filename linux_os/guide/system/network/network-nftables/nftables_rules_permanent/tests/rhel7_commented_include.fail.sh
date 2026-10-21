#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = nftables
# variables = var_nftables_master_config_file=/etc/sysconfig/nftables.conf

# The package ships its sample includes commented out. The remediation
# saves the running rule set, which this scenario loads first.
nft flush ruleset
nft add table inet filter
nft add chain inet filter input '{ type filter hook input priority 0; policy accept; }'
nft add chain inet filter forward '{ type filter hook forward priority 0; policy accept; }'
nft add chain inet filter output '{ type filter hook output priority 0; policy accept; }'
echo '# include "/etc/nftables/inet-filter"' > /etc/sysconfig/nftables.conf
