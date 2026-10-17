#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=0

{{% if product in [ 'sle16', 'slmicro6' ] %}}
touch /etc/sudoers
{{% endif %}}
sed -i '/timestamp_timeout/d' /etc/sudoers
# sudo skips the files of /etc/sudoers.d whose names contain a "."
echo "Defaults timestamp_timeout=0" > /etc/sudoers.d/cis_sudoers.conf
