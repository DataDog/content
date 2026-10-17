#!/bin/bash
# platform = multi_platform_debian,multi_platform_ubuntu
# packages = sudo
# variables = var_sudo_timestamp_timeout=5

# Debian and Ubuntu build sudo with a default of 15 minutes
sed -i '/timestamp_timeout/d' /etc/sudoers
