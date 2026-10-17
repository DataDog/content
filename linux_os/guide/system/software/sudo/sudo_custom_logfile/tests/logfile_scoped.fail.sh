#!/bin/bash
# platform = multi_platform_all
# packages = sudo

{{% if product in [ 'sle16', 'slmicro6' ] %}}
touch /etc/sudoers
{{% endif %}}
sed '/Defaults.*logfile/ s/.*/#&/g' -i /etc/sudoers /etc/sudoers.d/*
# A Defaults entry for one user leaves the others without a log file.
echo "Defaults:root logfile=/var/log/sudo.log" >> /etc/sudoers.d/logfile
