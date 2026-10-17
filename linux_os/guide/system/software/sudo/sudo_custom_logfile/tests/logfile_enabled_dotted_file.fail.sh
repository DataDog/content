#!/bin/bash
# platform = multi_platform_all
# packages = sudo

{{% if product in [ 'sle16', 'slmicro6' ] %}}
touch /etc/sudoers
{{% endif %}}
sed '/Defaults.*logfile/ s/.*/#&/g' -i /etc/sudoers /etc/sudoers.d/*
# sudo skips the files of /etc/sudoers.d whose names contain a "." or end in "~"
echo 'Defaults logfile="/var/log/sudo.log"' >> /etc/sudoers.d/cis_sudoers.conf
echo 'Defaults logfile="/var/log/sudo.log"' >> /etc/sudoers.d/enable_logfile~
