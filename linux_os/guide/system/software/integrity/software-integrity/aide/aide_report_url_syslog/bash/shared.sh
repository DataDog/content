# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

aide_conf="{{{ aide_conf_path }}}"
if ! grep -qE '^[[:space:]]*report_url[[:space:]]*=[[:space:]]*syslog:' "$aide_conf"; then
    if grep -qE '^[[:space:]]*report_url[[:space:]]*=' "$aide_conf"; then
        sed -i '0,/^[[:space:]]*report_url[[:space:]]*=.*/s//&\nreport_url=syslog:LOG_LOCAL0/' "$aide_conf"
    else
        echo "report_url=syslog:LOG_LOCAL0" >> "$aide_conf"
    fi
fi
