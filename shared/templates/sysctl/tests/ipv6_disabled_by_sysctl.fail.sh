#!/bin/bash
# platform = Red Hat Enterprise Linux 7
{{% if SYSCTLVAL == "" %}}
# variables = sysctl_{{{ SYSCTLID }}}_value={{{ SYSCTL_CORRECT_VALUE }}}
{{% endif %}}

# Clean sysctl config directories
rm -rf /usr/lib/sysctl.d/* /run/sysctl.d/* /etc/sysctl.d/*

sed -i "/{{{ SYSCTLVAR }}}/d" /etc/sysctl.conf
echo "{{{ SYSCTLVAR }}} = {{{ SYSCTL_WRONG_VALUE }}}" >> /etc/sysctl.conf
sysctl -w {{{ SYSCTLVAR }}}="{{{ SYSCTL_WRONG_VALUE }}}"

# IPv6 disabled by sysctl leaves the ipv6 module enabled, so the CIS RHEL 7
# audits still check the parameter. CIS Amazon Linux 2 counts IPv6 disabled
# when all.disable_ipv6 and default.disable_ipv6 are 1, and a write of
# all.disable_ipv6 sets default.disable_ipv6 too, so Amazon Linux 2 gets
# IPv6 disabled by default alone, where the parameter is still checked.
if grep -qs '^ID="\?amzn"\?$' /etc/os-release; then
    key=net.ipv6.conf.default.disable_ipv6
else
    key=net.ipv6.conf.all.disable_ipv6
fi
echo "$key = 1" >> /etc/sysctl.conf
sysctl -w "$key=1"
