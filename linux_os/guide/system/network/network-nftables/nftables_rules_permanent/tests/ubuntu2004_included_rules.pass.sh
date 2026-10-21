#!/bin/bash
# platform = Ubuntu 20.04
# packages = nftables
# variables = var_nftables_master_config_file=/etc/nftables.conf

cat >/etc/nftables.rules <<'RULES'
table inet filter {
	chain input {
		type filter hook input priority 0; policy accept;
	}
	chain forward {
		type filter hook forward priority 0; policy accept;
	}
	chain output {
		type filter hook output priority 0; policy accept;
	}
}
RULES
printf '#!/usr/sbin/nft -f\nflush ruleset\ninclude "/etc/nftables.rules"\n' >/etc/nftables.conf
