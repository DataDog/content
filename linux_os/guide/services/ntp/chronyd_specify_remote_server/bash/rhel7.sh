# platform = Red Hat Enterprise Linux 7

{{{ bash_instantiate_variables("var_multiple_time_servers") }}}

config_file="{{{ chrony_conf_path }}}"
source_regex='^[[:space:]]*(server|pool)[[:space:]]+[^#[:space:]]'

if grep -qs '^ID="\?amzn"\?$' /etc/os-release && grep -qs '^VERSION_ID="\?2"\?$' /etc/os-release; then
    # CIS Amazon Linux 2 reads the time sources from the files of
    # /etc/chrony.d, and chrony reads the .conf files there through confdir.
    if ! grep -Eqs "$source_regex" "$config_file" && ! grep -Erqs "$source_regex" /etc/chrony.d; then
        mkdir -p /etc/chrony.d
        IFS="," read -r -a servers <<< "$var_multiple_time_servers"
        for server in "${servers[@]}"; do
            printf 'server %s iburst\n' "$server"
        done >/etc/chrony.d/50-time-servers.conf
        chmod 0644 /etc/chrony.d/50-time-servers.conf
        if ! grep -Eqs '^[[:space:]]*(confdir([[:space:]]+[^#[:space:]]+)*[[:space:]]+/etc/chrony\.d/?([[:space:]]|$)|include[[:space:]]+/etc/chrony\.d/)' "$config_file"; then
            echo "confdir /etc/chrony.d" >>"$config_file"
        fi
    fi
elif ! grep -Eqs "$source_regex" "$config_file"; then
    # chrony 3.4 reads its time sources from chrony.conf alone.
    if [[ ! -f $config_file ]]; then
        touch "$config_file"
    fi
    {{{ bash_ensure_there_are_servers_in_ntp_compatible_config_file("$config_file", "$var_multiple_time_servers") | indent(4) }}}
fi
