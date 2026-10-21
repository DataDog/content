#!/bin/bash
# platform = Ubuntu 20.04
# packages = audit

echo "-w /etc/pam.d -p wa -k identity" >> /etc/audit/rules.d/50-identity.rules
