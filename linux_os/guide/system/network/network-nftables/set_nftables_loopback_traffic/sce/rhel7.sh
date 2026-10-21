#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# check-import = stdout

counter='(counter[[:space:]]+packets[[:space:]]+[0-9]+[[:space:]]+bytes[[:space:]]+[0-9]+[[:space:]]+)?'
input=$(nft list ruleset 2>/dev/null | awk '/hook input/,/}/')

if ! printf '%s\n' "$input" | grep -Eq "^[[:space:]]*iif[[:space:]]+\"?lo\"?[[:space:]]+${counter}accept"; then
    exit "${XCCDF_RESULT_FAIL}"
fi
if ! printf '%s\n' "$input" | grep -Eq "^[[:space:]]*ip[[:space:]]+saddr[[:space:]]+127\.0\.0\.0/8[[:space:]]+${counter}drop"; then
    exit "${XCCDF_RESULT_FAIL}"
fi
# The ipv6 module parameter decides whether IPv6 is enabled.
if grep -qs '^[[:space:]]*0' /sys/module/ipv6/parameters/disable &&
    ! printf '%s\n' "$input" | grep -Eq "^[[:space:]]*ip6[[:space:]]+saddr[[:space:]]+::1[[:space:]]+${counter}drop"; then
    exit "${XCCDF_RESULT_FAIL}"
fi
exit "${XCCDF_RESULT_PASS}"
