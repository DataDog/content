#!/bin/bash
# packages = chrony
# platform = Amazon Linux 2023

sed -i '/^\s*\(server\|pool\)\s/d' {{{ chrony_conf_path }}}
mkdir -p /etc/chrony.d
echo "server 169.254.169.123 prefer iburst" >/etc/chrony.d/link-local.conf
