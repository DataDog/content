#!/bin/bash
# platform = Ubuntu 20.04
# packages = aide

sed -i '/\/sbin\/au/d' /etc/aide/aide.conf
for tool in auditctl auditd ausearch aureport autrace augenrules; do
    echo "/sbin/$tool p+i+n+u+g+s+b+acl+xattrs+sha512" >> /etc/aide/aide.conf
done
