#!/bin/bash
# variables = var_sshd_max_sessions=4

mkdir -p "{{{ sshd_config_dir }}}"
touch "{{{ sshd_config_dir }}}/nothing"
declare -a SSHD_PATHS=({{{ sshd_main_config_file }}} {{{ sshd_config_dir }}}/*)

{{% if product in ['sle16', 'slmicro6'] %}}
touch "{{{ sshd_main_config_file }}}"
{{% endif %}}

sed -i "/^\s*MaxSessions/Id" "${SSHD_PATHS[@]}"
