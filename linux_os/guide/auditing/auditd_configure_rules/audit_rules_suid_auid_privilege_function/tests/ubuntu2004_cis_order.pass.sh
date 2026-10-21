#!/bin/bash
# platform = Ubuntu 20.04
# packages = audit

echo "-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation" >> /etc/audit/rules.d/50-user_emulation.rules
echo "-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation" >> /etc/audit/rules.d/50-user_emulation.rules
