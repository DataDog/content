#!/bin/bash
# platform = Ubuntu 24.04
# packages = aide
# variables = var_aide_audit_tools_sbin=true

sed -i '/\/sbin\/au/d' /etc/aide/aide.conf
for tool in {{{ aide_audit_binaries | join(" ") }}}; do
    echo "/usr/sbin/$tool p+i+n+u+g+s+b+acl+xattrs+sha512" >> /etc/aide/aide.conf
done
