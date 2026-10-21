#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# check-import = stdout

# The ipv6 module parameter decides whether IPv6 is enabled.
if ! grep -qs '^[[:space:]]*0' /sys/module/ipv6/parameters/disable; then
    exit "${XCCDF_RESULT_PASS}"
fi

policies=$(ip6tables -S 2>/dev/null)
for chain in INPUT FORWARD OUTPUT; do
    if ! printf '%s\n' "$policies" | grep -Eqx -- "-P $chain (DROP|REJECT)"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
done
exit "${XCCDF_RESULT_PASS}"
