#!/bin/bash
# platform = Ubuntu 20.04
# packages = aide
# variables = var_aide_audit_tools_cis=true

sed -i '/\/sbin\/au/d' /etc/aide/aide.conf
mkdir -p /etc/aide/aide.conf.d
for tool in auditctl auditd ausearch aureport autrace augenrules; do
    echo "/sbin/$tool p+i+n+u+g+s+b+acl+xattrs+sha512" >> /etc/aide/aide.conf.d/99_aide_audit_tools
done
