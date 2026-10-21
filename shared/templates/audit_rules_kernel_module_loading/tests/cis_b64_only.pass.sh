#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

rm -f /etc/audit/rules.d/*
> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>={{{ uid_min }}} -F auid!=unset -k kernel_modules" >> /etc/audit/rules.d/50-kernel_modules.rules
