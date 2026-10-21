#!/bin/bash
# platform = multi_platform_rhel
# check-import = stdout

# The ipv6 module parameter decides whether IPv6 is enabled.
if ! grep -qs '^[[:space:]]*0' /sys/module/ipv6/parameters/disable; then
    exit "${XCCDF_RESULT_PASS}"
fi

# filter prints the filter table of an ip6tables-save dump without
# comments and with the chain counters zeroed.
filter() {
    awk '/^\*filter$/ { f = 1 } f && !/^#/ { sub(/ \[[0-9]+:[0-9]+\]$/, " [0:0]"); print } f && /^COMMIT$/ { exit }'
}

running=$(ip6tables-save -t filter 2>/dev/null | filter)
saved=$(filter < /etc/sysconfig/ip6tables 2>/dev/null)
if [ -n "$running" ] && [ "$running" = "$saved" ]; then
    exit "${XCCDF_RESULT_PASS}"
fi
exit "${XCCDF_RESULT_FAIL}"
