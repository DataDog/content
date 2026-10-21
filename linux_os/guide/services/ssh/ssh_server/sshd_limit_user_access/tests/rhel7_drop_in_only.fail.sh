#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# remediation = none

# The sshd of OpenSSH 7.4 reads sshd_config alone, so it ignores this file.
source common.sh
mkdir -p "{{{ sshd_config_dir }}}"
echo "AllowUsers testuser1" > "{{{ sshd_config_dir }}}/50-access.conf"
