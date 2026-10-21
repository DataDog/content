#!/bin/bash
# platform = {{{ "Not Applicable" if VARIABLE == "dictcheck" else "Red Hat Enterprise Linux 7" }}}
# variables = var_password_pam_{{{ VARIABLE }}}={{{ TEST_VAR_VALUE }}}

# libpwquality 1.2.3 reads pwquality.conf alone.
truncate -s 0 "{{{ pwquality_path }}}"
mkdir -p /etc/security/pwquality.conf.d
echo "{{{ VARIABLE }}} = {{{ TEST_CORRECT_VALUE }}}" > /etc/security/pwquality.conf.d/test_file.conf
