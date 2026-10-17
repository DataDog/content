#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=15

{{% if product in [ 'sle16', 'slmicro6' ] %}}
touch /etc/sudoers
{{% endif %}}
# The sudo default (5 minutes, 15 on Debian and Ubuntu) is within 15 minutes
sed -i '/timestamp_timeout/d' /etc/sudoers
