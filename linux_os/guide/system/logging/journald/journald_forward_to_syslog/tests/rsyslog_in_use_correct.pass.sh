#!/bin/bash
# packages = rsyslog
# platform = Red Hat Enterprise Linux 7

sed -i '/^\s*ForwardToSyslog\s*=/d' /etc/systemd/journald.conf {{{ journald_conf_dir_path }}}/*.conf 2>/dev/null || true
if grep -q '^\[Journal\]' /etc/systemd/journald.conf; then
    sed -i '/^\[Journal\]/a ForwardToSyslog=yes' /etc/systemd/journald.conf
else
    printf '[Journal]\nForwardToSyslog=yes\n' >> /etc/systemd/journald.conf
fi
