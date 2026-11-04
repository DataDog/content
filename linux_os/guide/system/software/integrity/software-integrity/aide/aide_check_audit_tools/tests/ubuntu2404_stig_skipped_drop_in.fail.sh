#!/bin/bash
# platform = Ubuntu 24.04
# packages = aide
# variables = var_aide_audit_tools_sbin=true

# AIDE reads the drop-in files whose names match ^[a-zA-Z0-9_-]+$ alone.
sed -i '/\/sbin\/au/d' /etc/aide/aide.conf
mkdir -p /etc/aide/aide.conf.d
for dir in /usr/sbin /sbin; do
    for tool in {{{ aide_audit_binaries | join(" ") }}}; do
        echo "$dir/$tool p+i+n+u+g+s+b+acl+xattrs+sha512" >> /etc/aide/aide.conf.d/90-stig_audit_tools.conf
    done
done
