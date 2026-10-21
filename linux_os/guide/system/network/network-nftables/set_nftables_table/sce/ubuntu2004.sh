#!/bin/bash
# platform = Ubuntu 20.04
# check-import = stdout

# A table of any family and name counts.
if nft list tables 2>/dev/null | grep -Eq '^table[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+'; then
    exit "${XCCDF_RESULT_PASS}"
fi
exit "${XCCDF_RESULT_FAIL}"
