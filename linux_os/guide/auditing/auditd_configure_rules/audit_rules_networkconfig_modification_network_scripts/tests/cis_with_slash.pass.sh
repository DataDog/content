#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

rm -f /etc/audit/rules.d/*.rules
echo "-w /etc/sysconfig/network-scripts/ -p wa -k system-locale" > /etc/audit/rules.d/50-system_locale.rules
