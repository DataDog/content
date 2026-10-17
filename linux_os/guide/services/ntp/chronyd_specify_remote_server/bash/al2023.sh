# platform = multi_platform_al

{{{ bash_instantiate_variables("var_multiple_time_servers") }}}

if ! grep -Prqs '^\s*(server|pool)\s+[^#\s]' /etc/chrony.d/; then
    mkdir -p /etc/chrony.d
    IFS="," read -r -a servers <<< "$var_multiple_time_servers"
    for server in "${servers[@]}"; do
        printf 'server %s iburst\n' "$server"
    done >/etc/chrony.d/50-time-servers.conf
    chmod 0644 /etc/chrony.d/50-time-servers.conf
fi

if ! grep -Pqs '^\s*confdir(\s+\S+)*\s+/etc/chrony\.d/?(\s|$)|^\s*include\s+/etc/chrony\.d/\*(\.conf)?\s*$' {{{ chrony_conf_path }}}; then
    echo "confdir /etc/chrony.d" >>{{{ chrony_conf_path }}}
fi
