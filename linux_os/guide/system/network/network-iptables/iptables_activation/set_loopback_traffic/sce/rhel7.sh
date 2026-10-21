#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# check-import = stdout

rules=$(iptables -S 2>/dev/null)
for rule in '-A INPUT -i lo -j ACCEPT' '-A INPUT -s 127.0.0.0/8 -j DROP' '-A OUTPUT -o lo -j ACCEPT'; do
    if ! printf '%s\n' "$rules" | grep -qxF -- "$rule"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
done
# The loopback interface is accepted before the loopback network is dropped.
if ! printf '%s\n' "$rules" | awk '$0 == "-A INPUT -i lo -j ACCEPT" && !drop { ok = 1 }
    $0 == "-A INPUT -s 127.0.0.0/8 -j DROP" { drop = 1 } END { exit !ok }'; then
    exit "${XCCDF_RESULT_FAIL}"
fi
exit "${XCCDF_RESULT_PASS}"
