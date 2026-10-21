#!/bin/bash
# packages = chrony
# platform = Red Hat Enterprise Linux 7

# The layout of chrony 4 on Amazon Linux 2: chrony.conf names /etc/chrony.d,
# whose files hold the time sources.
cat > {{{ chrony_conf_path }}} << CONF
sourcedir /run/chrony-dhcp
confdir /etc/chrony.d
sourcedir /etc/chrony.d
driftfile /var/lib/chrony/drift
CONF
rm -rf /etc/chrony.d
mkdir -p /etc/chrony.d
echo "server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4" > /etc/chrony.d/link-local.sources
