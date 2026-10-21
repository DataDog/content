#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

rm -f /etc/audit/rules.d/*.rules
echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/rules.d/50-scope.rules
echo "-w /etc/sudoers.d -p wa -k scope" >> /etc/audit/rules.d/50-scope.rules
