#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

rm -rf /etc/audit/rules.d/*.rules
echo "-a always,exit -F arch=b32 -S clock_settime -F a0=0x0 -k time-change" >> /etc/audit/rules.d/time.rules
# Amazon Linux 2 accepts the a0=0x0 rules of its benchmark, so leave out
# the 64-bit rule there.
if ! grep -qs '^ID="amzn"' /etc/os-release; then
	echo "-a always,exit -F arch=b64 -S clock_settime -F a0=0x0 -k time-change" >> /etc/audit/rules.d/time.rules
fi
