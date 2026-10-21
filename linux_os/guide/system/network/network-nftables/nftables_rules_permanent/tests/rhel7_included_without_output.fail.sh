#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = nftables
# variables = var_nftables_master_config_file=/etc/sysconfig/nftables.conf
# remediation = none

mkdir -p /etc/nftables
cat > /etc/nftables/nftables.rules <<'RULES'
table inet filter {
	chain input {
		type filter hook input priority 0; policy drop;
	}
	chain forward {
		type filter hook forward priority 0; policy drop;
	}
}
RULES
echo 'include "/etc/nftables/nftables.rules"' > /etc/sysconfig/nftables.conf
