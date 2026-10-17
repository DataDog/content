#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=15

sed -i '/timestamp_timeout/d' /etc/sudoers
echo "Defaults env_reset,timestamp_timeout=30" >> /etc/sudoers
echo "Defaults timestamp_timeout=20, use_pty" >> /etc/sudoers
