#!/bin/bash
# packages = rsyslog
# platform = Red Hat Enterprise Linux 7

# journald forwards to syslog by default, and CIS Amazon Linux 2 v4.0.0
# 6.1.1.5 passes a configuration without ForwardToSyslog. RHEL 7 requires
# the setting, so set it there.
rm -f {{{ journald_conf_dir_path }}}/*.conf
sed -i '/^\s*ForwardToSyslog\s*=/d' /etc/systemd/journald.conf
if ! grep -qs '^ID="amzn"' /etc/os-release; then
	printf '%s\n' '[Journal]' 'ForwardToSyslog=yes' > /etc/systemd/journald.conf
fi
