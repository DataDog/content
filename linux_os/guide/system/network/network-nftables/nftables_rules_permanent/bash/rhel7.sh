# platform = Red Hat Enterprise Linux 7
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_instantiate_variables("var_nftables_master_config_file") }}}

# Save the running rule set and include it, unless the configuration
# includes files already: those are the site's to complete.
if ! grep -Eqs '^[[:space:]]*include[[:space:]]' "$var_nftables_master_config_file"; then
    mkdir -p /etc/nftables
    (umask 077 && nft list ruleset > /etc/nftables/nftables.rules)
    echo 'include "/etc/nftables/nftables.rules"' >> "$var_nftables_master_config_file"
fi
