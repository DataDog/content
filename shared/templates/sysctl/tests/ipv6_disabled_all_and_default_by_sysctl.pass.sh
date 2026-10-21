#!/bin/bash
# platform = {{{ "Red Hat Enterprise Linux 7" if IPV6 == "true" else "Not Applicable" }}}
{{% if SYSCTLVAL == "" %}}
# variables = sysctl_{{{ SYSCTLID }}}_value={{{ SYSCTL_CORRECT_VALUE }}}
{{% endif %}}

# Clean sysctl config directories
rm -rf /usr/lib/sysctl.d/* /run/sysctl.d/* /etc/sysctl.d/*

sed -i "/{{{ SYSCTLVAR }}}/d" /etc/sysctl.conf

# CIS Amazon Linux 2 skips the IPv6 parameters when the running kernel
# disables IPv6 on all interfaces and by default, so Amazon Linux 2 keeps a
# wrong value here. The CIS RHEL 7 audits read the ipv6 module alone, so
# RHEL 7 gets the correct value.
if grep -qs '^ID="\?amzn"\?$' /etc/os-release; then
    value="{{{ SYSCTL_WRONG_VALUE }}}"
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
else
    value="{{{ SYSCTL_CORRECT_VALUE }}}"
fi
echo "{{{ SYSCTLVAR }}} = $value" >> /etc/sysctl.conf
sysctl -w {{{ SYSCTLVAR }}}="$value"
