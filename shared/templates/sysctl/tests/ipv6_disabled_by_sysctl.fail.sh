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

# IPv6 disabled by sysctl leaves the ipv6 module enabled, so the
# parameter is still checked.
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -w net.ipv6.conf.all.disable_ipv6=1
