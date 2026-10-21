#!/bin/bash
# platform = Ubuntu 20.04
# packages = audit

echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/rules.d/50-scope.rules
echo "-w /etc/sudoers.d -p wa -k scope" >> /etc/audit/rules.d/50-scope.rules
