#!/bin/bash
# platform = multi_platform_rhel,AlmaLinux OS 9,Amazon Linux 2023
# variables = sshd_idle_timeout_value=300,var_sshd_set_keepalive=1

# These products check ClientAliveCountMax with sshd_set_keepalive alone.
mkdir -p "{{{ sshd_config_dir }}}"
touch "{{{ sshd_config_dir }}}/nothing"
declare -a SSHD_PATHS=({{{ sshd_main_config_file }}} {{{ sshd_config_dir }}}/*)

sed -i "/^\s*ClientAlive/Id" "${SSHD_PATHS[@]}"
echo "ClientAliveInterval 15" >> "{{{ sshd_main_config_file }}}"
echo "ClientAliveCountMax 3" >> "{{{ sshd_main_config_file }}}"
