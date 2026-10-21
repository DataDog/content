#!/bin/bash
# packages = chrony
# platform = Red Hat Enterprise Linux 7

# The layout of chrony 4 on Amazon Linux 2 with its time source commented
# out. The fix writes the sources to /etc/chrony.d: the first sourcedir,
# /run/chrony-dhcp, is a run time directory.
cat > {{{ chrony_conf_path }}} << CONF
sourcedir /run/chrony-dhcp
confdir /etc/chrony.d
sourcedir /etc/chrony.d
driftfile /var/lib/chrony/drift
CONF
rm -rf /etc/chrony.d /run/chrony-dhcp
mkdir -p /etc/chrony.d
echo "#server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4" > /etc/chrony.d/link-local.sources
