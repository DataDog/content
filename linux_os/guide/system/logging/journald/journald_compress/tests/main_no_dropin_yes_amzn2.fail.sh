#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# CIS Amazon Linux 2 v4.0.0 6.1.1.3 fails Compress=no in journald.conf even
# where a dropin sets yes. RHEL 7 lets the dropin decide, so set no in the
# dropin there.
mkdir -p {{{ journald_conf_dir_path }}}
rm -f {{{ journald_conf_dir_path }}}/*.conf
if grep -qs '^ID="amzn"' /etc/os-release; then
	printf '%s\n' '[Journal]' 'Compress=no' > /etc/systemd/journald.conf
	printf '%s\n' '[Journal]' 'Compress=yes' > {{{ journald_conf_dir_path }}}/60-journald.conf
else
	printf '%s\n' '[Journal]' 'Compress=yes' > /etc/systemd/journald.conf
	printf '%s\n' '[Journal]' 'Compress=no' > {{{ journald_conf_dir_path }}}/60-journald.conf
fi
