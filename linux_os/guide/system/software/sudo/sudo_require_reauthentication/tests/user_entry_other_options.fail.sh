#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=15

sed -i '/timestamp_timeout/d' /etc/sudoers
echo "Defaults:root log_input, log_output, timestamp_timeout=60" > /etc/sudoers.d/00-complianceascode-test
chmod 0440 /etc/sudoers.d/00-complianceascode-test
