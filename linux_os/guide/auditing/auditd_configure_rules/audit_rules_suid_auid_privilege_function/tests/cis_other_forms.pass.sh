#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

rm -f /etc/audit/rules.d/*.rules
echo "-a always,exit -F arch=b64 -S execve -F auid!=-1 -C uid!=euid -F key=user_emulation" >> /etc/audit/rules.d/50-user_emulation.rules
echo "-a always,exit -F arch=b32 -F auid!=4294967295 -S execve -C uid!=euid -F key=user_emulation" >> /etc/audit/rules.d/50-user_emulation.rules
