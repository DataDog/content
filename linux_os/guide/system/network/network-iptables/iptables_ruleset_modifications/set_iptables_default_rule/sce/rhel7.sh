#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# check-import = stdout

policies=$(iptables -S 2>/dev/null)
for chain in INPUT FORWARD OUTPUT; do
    if ! printf '%s\n' "$policies" | grep -Eqx -- "-P $chain (DROP|REJECT)"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
done
exit "${XCCDF_RESULT_PASS}"
