#!/bin/bash
# platform = Amazon Linux 2023,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,multi_platform_almalinux,multi_platform_fedora,multi_platform_ubuntu

{{% if XCCDF_VARIABLE %}}
# variables = {{{ XCCDF_VARIABLE }}}={{{ CORRECT_VALUE }}}
{{% endif %}}

source common.sh

# Remove the Include lines: sshd then reads {{{ sshd_main_config_file }}} alone.
sed -i '/^[[:space:]]*Include[[:space:]]/Id' "{{{ sshd_main_config_file }}}"
echo "{{{ PARAMETER }}} {{{ WRONG_VALUE }}}" >> "{{{ sshd_main_config_file }}}"
