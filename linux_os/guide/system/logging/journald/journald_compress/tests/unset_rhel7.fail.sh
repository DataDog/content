#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# CIS RHEL 7 v4.0.0 5.1.2.3 requires Compress=yes in journald.conf.
# Amazon Linux 2 passes a missing Compress, so turn compression off there.
rm -f {{{ journald_conf_dir_path }}}/*.conf
sed -i '/^\s*Compress\s*=/d' /etc/systemd/journald.conf
if grep -qs '^ID="amzn"' /etc/os-release; then
	printf '%s\n' '[Journal]' 'Compress=no' > /etc/systemd/journald.conf
fi
