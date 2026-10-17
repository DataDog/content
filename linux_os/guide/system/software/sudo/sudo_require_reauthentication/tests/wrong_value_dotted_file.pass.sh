#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=15

{{% if product in [ 'sle16', 'slmicro6' ] %}}
touch /etc/sudoers
{{% endif %}}
sed -i '/timestamp_timeout/d' /etc/sudoers
# sudo skips the files of /etc/sudoers.d whose names contain a "." or end in "~"
echo "Defaults timestamp_timeout=-1" > /etc/sudoers.d/cis_sudoers.conf
echo "Defaults timestamp_timeout=-1" > /etc/sudoers.d/00-complianceascode-test~
