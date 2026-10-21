#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# check-import = stdout

# The ipv6 module parameter decides whether IPv6 is enabled.
if ! grep -qs '^[[:space:]]*0' /sys/module/ipv6/parameters/disable; then
    exit "${XCCDF_RESULT_PASS}"
fi

# Every port open on an address other than ::1 needs a rule of its
# protocol in the INPUT chain, with the port in --dport or --dports.
rules=$(ip6tables -S INPUT 2>/dev/null)
while read -r proto port; do
    if ! printf '%s\n' "$rules" |
        grep -Eiq -- "-p $proto .*--dports? ([0-9]+[,:])*$port([^0-9]|$)"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
done < <(ss -6tulnH | awk '$5 !~ /^\[?::1\]?:/ { n = split($5, a, ":"); print $1, a[n] }' | sort -u)
exit "${XCCDF_RESULT_PASS}"
