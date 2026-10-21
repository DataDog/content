#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# check-import = stdout

# Every port open on an address outside 127.0.0.0/8 needs a rule of its
# protocol in the INPUT chain, with the port in --dport or --dports.
rules=$(iptables -S INPUT 2>/dev/null)
while read -r proto port; do
    if ! printf '%s\n' "$rules" |
        grep -Eiq -- "-p $proto .*--dports? ([0-9]+[,:])*$port([^0-9]|$)"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
done < <(ss -4tulnH | awk '$5 !~ /^127\./ { n = split($5, a, ":"); print $1, a[n] }' | sort -u)
exit "${XCCDF_RESULT_PASS}"
