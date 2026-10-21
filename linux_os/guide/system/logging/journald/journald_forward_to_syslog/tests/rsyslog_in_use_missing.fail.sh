#!/bin/bash
# packages = rsyslog
# platform = Red Hat Enterprise Linux 7

sed -i '/^\s*ForwardToSyslog\s*=/d' /etc/systemd/journald.conf {{{ journald_conf_dir_path }}}/*.conf 2>/dev/null || true
# Amazon Linux 2 passes a missing ForwardToSyslog, so turn forwarding off there.
if grep -qs '^ID="amzn"' /etc/os-release; then
	printf '%s\n' '[Journal]' 'ForwardToSyslog=no' > /etc/systemd/journald.conf
fi
