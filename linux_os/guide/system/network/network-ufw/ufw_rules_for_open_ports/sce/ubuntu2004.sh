#!/bin/bash
# platform = Ubuntu 20.04
# check-import = stdout

# As the audit script: a port has a rule when it is the destination port
# of a rule ufw loads (ufw show raw), or in the ports or ranges of a
# multiport rule of /etc/ufw/user.rules. The open ports are those that
# ss lists on addresses other than loopback.
rule_ports() {
    ufw show raw 2>&1 | grep -Po 'dpt:\K\d+'
    awk -F'--dports ' 'NF > 1 { split($2, f, " "); print f[1] }' /etc/ufw/user.rules |
        tr ',' '\n' |
        while IFS=: read -r first last; do
            if [ -n "$last" ]; then
                seq "$first" "$last"
            else
                echo "$first"
            fi
        done
}

open_ports() {
    ss -tuln | awk '($5 !~ /%lo:/ && $5 !~ /^127\./ && $5 !~ /\[?::1\]?:/) { split($5, a, ":"); print a[2] }'
}

missing=$(comm -23 <(open_ports | grep -E '^[0-9]+$' | sort -u) <(rule_ports | sort -u))
if [ -n "$missing" ]; then
    exit "$XCCDF_RESULT_FAIL"
fi
exit "$XCCDF_RESULT_PASS"
