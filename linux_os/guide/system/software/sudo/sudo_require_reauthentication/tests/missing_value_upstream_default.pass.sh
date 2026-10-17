#!/bin/bash
# platform = multi_platform_al,multi_platform_almalinux,multi_platform_fedora,multi_platform_ol,multi_platform_rhel
# packages = sudo
# variables = var_sudo_timestamp_timeout=5

# sudo is built with the upstream default of 5 minutes
sed -i '/timestamp_timeout/d' /etc/sudoers
