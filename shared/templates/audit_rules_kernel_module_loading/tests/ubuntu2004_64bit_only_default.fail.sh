#!/bin/bash
# platform = Ubuntu 20.04
# packages = audit

rm -f /etc/audit/rules.d/*
> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S {{{ NAME }}} -F auid>={{{ uid_min }}} -F auid!=unset -k kernel_modules" >> /etc/audit/rules.d/kernel_modules.rules
