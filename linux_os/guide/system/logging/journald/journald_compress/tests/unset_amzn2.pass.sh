#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# Amazon Linux 2 compresses the journal by default, and CIS Amazon Linux 2
# v4.0.0 6.1.1.3 passes a configuration without Compress. RHEL 7 requires
# the setting, so set it there.
rm -f {{{ journald_conf_dir_path }}}/*.conf
sed -i '/^\s*Compress\s*=/d' /etc/systemd/journald.conf
if ! grep -qs '^ID="amzn"' /etc/os-release; then
	printf '%s\n' '[Journal]' 'Compress=yes' > /etc/systemd/journald.conf
fi
