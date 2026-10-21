#!/bin/bash
{{#- On RHEL 7 the dictcheck remediation removes the option, which libpwquality 1.2.3 rejects. #}}
{{%- if product == "rhel7" and VARIABLE == "dictcheck" %}}
# platform = Not Applicable
{{%- endif %}}
# variables = var_password_pam_{{{ VARIABLE }}}={{{ TEST_VAR_VALUE }}}

# This test will ensure that the remediation also applies the configuration in
# /etc/security/pwquality.conf.d/*.conf files

truncate -s 0 "{{{ pwquality_path }}}"

config_dir="/etc/security/pwquality.conf.d"
mkdir -p $config_dir
echo "{{{ VARIABLE }}} = {{{ TEST_WRONG_VALUE }}}" >> $config_dir/test_file.conf
