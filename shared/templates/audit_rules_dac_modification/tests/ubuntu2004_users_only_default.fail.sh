#!/bin/bash
# platform = Ubuntu 20.04
# packages = audit

rm -f /etc/audit/rules.d/*
> /etc/audit/audit.rules

{{% if CHECK_ROOT_USER %}}
echo "-a always,exit -F arch=b32 -S {{{ ATTR }}} -F auid>={{{ uid_min }}} -F auid!=unset -F key={{{ KEY }}}" >> /etc/audit/rules.d/{{{ KEY }}}.rules
echo "-a always,exit -F arch=b64 -S {{{ ATTR }}} -F auid>={{{ uid_min }}} -F auid!=unset -F key={{{ KEY }}}" >> /etc/audit/rules.d/{{{ KEY }}}.rules
{{% endif %}}
