#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# check-import = stdout

# A table of any family counts.
if nft list tables 2>/dev/null | grep -Eq '^table[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+'; then
    exit "${XCCDF_RESULT_PASS}"
fi
exit "${XCCDF_RESULT_FAIL}"
