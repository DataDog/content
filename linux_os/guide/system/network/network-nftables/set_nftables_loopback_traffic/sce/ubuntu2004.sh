#!/bin/bash
# platform = Ubuntu 20.04
# check-import = stdout

# The input base chain accepts loopback traffic and drops the IPv4
# loopback network, and the IPv6 loopback address when IPv6 is enabled,
# with or without a counter, as in the expected output of the audit.
output=$(nft list ruleset | awk '/hook input/,/}/')
counter='(counter packets [0-9]+ bytes [0-9]+ )?'
if ! grep -Eq "^[[:space:]]*iif \"lo\" ${counter}accept" <<< "$output"; then
    exit "${XCCDF_RESULT_FAIL}"
fi
if ! grep -Eq "^[[:space:]]*ip saddr 127\.0\.0\.0/8 ${counter}drop" <<< "$output"; then
    exit "${XCCDF_RESULT_FAIL}"
fi
if [ -e /proc/sys/net/ipv6/conf/all/disable_ipv6 ] && [ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)" -eq 0 ]; then
    if ! grep -Eq "^[[:space:]]*ip6 saddr ::1 ${counter}drop" <<< "$output"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
fi
exit "${XCCDF_RESULT_PASS}"
