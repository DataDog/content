#!/bin/bash
# platform = multi_platform_rhel
# check-import = stdout

# filter prints the filter table of an iptables-save dump without
# comments and with the chain counters zeroed.
filter() {
    awk '/^\*filter$/ { f = 1 } f && !/^#/ { sub(/ \[[0-9]+:[0-9]+\]$/, " [0:0]"); print } f && /^COMMIT$/ { exit }'
}

running=$(iptables-save -t filter 2>/dev/null | filter)
saved=$(filter < /etc/sysconfig/iptables 2>/dev/null)
if [ -n "$running" ] && [ "$running" = "$saved" ]; then
    exit "${XCCDF_RESULT_PASS}"
fi
exit "${XCCDF_RESULT_FAIL}"
