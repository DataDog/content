#!/bin/bash
# variables = var_sshd_set_keepalive=3

mkdir -p "{{{ sshd_config_dir }}}"
touch "{{{ sshd_config_dir }}}/nothing"
declare -a SSHD_PATHS=({{{ sshd_main_config_file }}} {{{ sshd_config_dir }}}/*)

{{% if product in ['sle16', 'slmicro6'] %}}
touch "{{{ sshd_main_config_file }}}"
{{% endif %}}

sed -i "/^\s*ClientAliveCountMax/Id" "${SSHD_PATHS[@]}"
echo "ClientAliveCountMax 1" >> "{{{ sshd_main_config_file }}}"
