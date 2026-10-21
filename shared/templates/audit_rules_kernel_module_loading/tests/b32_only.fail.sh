#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

rm -f /etc/audit/rules.d/*
> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S {{{ NAME }}} -F auid>={{{ uid_min }}} -F auid!=unset -k kernel_modules" >> /etc/audit/rules.d/50-kernel_modules.rules
