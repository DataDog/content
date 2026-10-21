#!/bin/bash
# platform = Ubuntu 20.04
# packages = audit

echo "-w /etc/apparmor.d/ -p wa -k MAC-policy" >> /etc/audit/rules.d/50-MAC-policy.rules
