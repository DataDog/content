#!/bin/bash
# platform = Ubuntu 20.04
# check-import = stdout

# Every TCP or UDP port open on an IPv4 address other than loopback has a
# rule for that destination port in the INPUT chain.
result=$XCCDF_RESULT_PASS
iptables_status="$(iptables -L INPUT -v -n)"

while read -r lpn;
do
    if ! grep -Pq "dpt:$lpn\b" <<< "$iptables_status"; then
        result=$XCCDF_RESULT_FAIL
        break
    fi
done < <(ss -4tuln | awk '($5 !~ /%lo:/ && $5 !~ /^127\./) { split($5, a, ":"); print a[2] }' | grep -E '^[0-9]+$' | sort -u)

exit "$result"
