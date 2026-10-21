#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_password_pam_{{{ VARIABLE }}}={{{ TEST_VAR_VALUE }}}

truncate -s 0 "{{{ pwquality_path }}}"
echo "{{{ VARIABLE }}} = {{{ TEST_CORRECT_VALUE }}}" >> "{{{ pwquality_path }}}"
. $SHARED/pam_rhel7.sh
PWQUALITY_ARGS="try_first_pass local_users_only retry=3 {{{ VARIABLE }}}={{{ TEST_CORRECT_VALUE }}}" rhel7_cis_pam_files
