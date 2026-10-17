#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=15

sed -i '/timestamp_timeout/d' /etc/sudoers
echo "Defaults timestamp_timeout=15.5" >> /etc/sudoers
