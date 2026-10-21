#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

rm -f /etc/audit/rules.d/*.rules
echo "-w /etc/selinux -p wa -k MAC-policy" > /etc/audit/rules.d/50-MAC-policy.rules
echo "-w /usr/share/selinux -p wa -k MAC-policy" >> /etc/audit/rules.d/50-MAC-policy.rules
