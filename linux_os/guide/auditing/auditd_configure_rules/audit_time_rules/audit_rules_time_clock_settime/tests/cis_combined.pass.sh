#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

rm -rf /etc/audit/rules.d/*.rules
echo "-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change" >> /etc/audit/rules.d/50-time-change.rules
echo "-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change" >> /etc/audit/rules.d/50-time-change.rules
