#!/bin/bash
# platform = Ubuntu 24.04
# packages = aide
# variables = var_aide_audit_tools_sbin=true

# aide.conf includes its drop-in directory before the appended lines, and
# the first entry of a path wins.
sed -i '/\/sbin\/au/d' /etc/aide/aide.conf
for dir in /usr/sbin /sbin; do
    for tool in {{{ aide_audit_binaries | join(" ") }}}; do
        echo "$dir/$tool p+i+n+u+g+s+b+acl+xattrs+sha512" >> /etc/aide/aide.conf
    done
done
mkdir -p /etc/aide/aide.conf.d
echo "/usr/sbin/auditctl p+i+n+u+g+s+b+acl+xattrs+sha256" > /etc/aide/aide.conf.d/90-stig_audit_tools
