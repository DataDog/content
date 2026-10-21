#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

# CIS Amazon Linux 2 v4.0.0 6.2.3.4 audits clock_settime in a rule of its
# own with -F a0=0x0. CIS RHEL 7 v4.0.0 5.2.3.4 audits it with the other
# time syscalls and no filter, so write that form there.
rm -rf /etc/audit/rules.d/*.rules
if grep -qs '^ID="amzn"' /etc/os-release; then
	echo "-a always,exit -F arch=b32 -S clock_settime -F a0=0x0 -k time-change" >> /etc/audit/rules.d/time.rules
	echo "-a always,exit -F arch=b64 -S clock_settime -F a0=0x0 -k time-change" >> /etc/audit/rules.d/time.rules
else
	echo "-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change" >> /etc/audit/rules.d/time.rules
	echo "-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change" >> /etc/audit/rules.d/time.rules
fi
