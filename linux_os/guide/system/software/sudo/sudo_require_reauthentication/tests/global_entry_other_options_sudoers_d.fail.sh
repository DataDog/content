#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=15

sed -i '/timestamp_timeout/d' /etc/sudoers
echo "Defaults env_reset, timestamp_timeout=60, mail_badpass" > /etc/sudoers.d/00-complianceascode-test
chmod 0440 /etc/sudoers.d/00-complianceascode-test
