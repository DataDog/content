#!/bin/bash
# platform = Ubuntu 20.04
# check-import = stdout

ufw_status=$(ufw status verbose)
ipv6=no
if [ -e /proc/sys/net/ipv6/conf/all/disable_ipv6 ] && [ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)" -eq 0 ]; then
    ipv6=yes
fi

# The loopback interface accepts traffic through the rules ufw ships in
# /etc/ufw/before.rules and before6.rules, or through rules added with
# ufw allow in on lo and ufw allow out on lo.
if ! grep -Eq '^-A ufw-before-input -i lo -j ACCEPT[[:space:]]*$' /etc/ufw/before.rules &&
    ! grep -Eq '^Anywhere on lo\s+ALLOW IN\s+Anywhere' <<< "$ufw_status"; then
    exit "${XCCDF_RESULT_FAIL}"
fi
if ! grep -Eq '^-A ufw-before-output -o lo -j ACCEPT[[:space:]]*$' /etc/ufw/before.rules &&
    ! grep -Eq '^Anywhere\s+ALLOW OUT\s+Anywhere on lo' <<< "$ufw_status"; then
    exit "${XCCDF_RESULT_FAIL}"
fi
if [ "$ipv6" = yes ]; then
    if ! grep -Eq '^-A ufw6-before-input -i lo -j ACCEPT[[:space:]]*$' /etc/ufw/before6.rules &&
        ! grep -Eq '^Anywhere \(v6\) on lo\s+ALLOW IN\s+Anywhere \(v6\)' <<< "$ufw_status"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
    if ! grep -Eq '^-A ufw6-before-output -o lo -j ACCEPT[[:space:]]*$' /etc/ufw/before6.rules &&
        ! grep -Eq '^Anywhere \(v6\)\s+ALLOW OUT\s+Anywhere \(v6\) on lo' <<< "$ufw_status"; then
        exit "${XCCDF_RESULT_FAIL}"
    fi
fi

# The other interfaces deny traffic from the loopback addresses.
if ! grep -Eq '^Anywhere\s+DENY IN\s+127\.0\.0\.0/8' <<< "$ufw_status"; then
    exit "${XCCDF_RESULT_FAIL}"
fi
if [ "$ipv6" = yes ] && ! grep -Eq '^Anywhere \(v6\)\s+DENY IN\s+::1' <<< "$ufw_status"; then
    exit "${XCCDF_RESULT_FAIL}"
fi

exit "${XCCDF_RESULT_PASS}"
