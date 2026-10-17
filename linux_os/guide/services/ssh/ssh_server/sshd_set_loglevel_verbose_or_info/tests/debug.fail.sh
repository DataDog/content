#!/bin/bash

mkdir -p "{{{ sshd_config_dir }}}"
touch "{{{ sshd_config_dir }}}/nothing"
declare -a SSHD_PATHS=({{{ sshd_main_config_file }}} {{{ sshd_config_dir }}}/*)

{{% if product in ['sle16', 'slmicro6'] %}}
touch "{{{ sshd_main_config_file }}}"
{{% endif %}}

sed -i "/^\s*LogLevel/Id" "${SSHD_PATHS[@]}"
echo "LogLevel DEBUG" >> "{{{ sshd_main_config_file }}}"
