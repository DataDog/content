#!/bin/bash
# platform = multi_platform_all
# packages = sudo

{{% if product in [ 'sle16', 'slmicro6' ] %}}
touch /etc/sudoers
{{% endif %}}
sed '/Defaults.*use_pty/ s/.*/#&/g' -i /etc/sudoers /etc/sudoers.d/*
# sudo skips the files of /etc/sudoers.d whose names contain a "." or end in "~"
echo "Defaults use_pty" >> /etc/sudoers.d/cis_sudoers.conf
echo "Defaults use_pty" >> /etc/sudoers.d/enable_use_pty~
