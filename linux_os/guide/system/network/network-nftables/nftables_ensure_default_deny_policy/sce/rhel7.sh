#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# check-import = stdout

ruleset=$(nft list ruleset 2>/dev/null)
for hook in input forward output; do
    if ! printf '%s\n' "$ruleset" |
        grep -Eq "^[[:space:]]*type[[:space:]]+filter[[:space:]]+hook[[:space:]]+${hook}[[:space:]]+(priority[[:space:]]+[^[:space:]]+;[[:space:]]+)?policy[[:space:]]+drop;"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
done
exit "${XCCDF_RESULT_PASS}"
