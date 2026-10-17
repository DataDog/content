#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=15

sed -i '/timestamp_timeout/d' /etc/sudoers
echo "Defaults env_reset, timestamp_timeout=60" >> /etc/sudoers
