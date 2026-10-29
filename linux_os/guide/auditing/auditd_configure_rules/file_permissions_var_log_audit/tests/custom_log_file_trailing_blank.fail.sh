#!/bin/bash
# platform = multi_platform_all
# packages = audit

# auditd reads a value up to the spaces that end its line.
sed -i '/^log_file/d; /^log_group/d' /etc/audit/auditd.conf
echo "log_file = /var/log/audit/custom.log " >> /etc/audit/auditd.conf
echo "log_group = root" >> /etc/audit/auditd.conf

mkdir -p /var/log/audit
touch /var/log/audit/audit.log /var/log/audit/custom.log
chmod 0600 /var/log/audit/audit.log
chmod 0644 /var/log/audit/custom.log
