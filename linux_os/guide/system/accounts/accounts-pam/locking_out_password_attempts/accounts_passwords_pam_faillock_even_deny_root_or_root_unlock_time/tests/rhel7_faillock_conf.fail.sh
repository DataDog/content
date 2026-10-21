#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_passwords_pam_faillock_root_unlock_time=60

# pam_faillock of PAM 1.1.8 reads its options from the PAM lines only.
. $SHARED/pam_rhel7.sh
FAILLOCK_ARGS="audit deny=5 unlock_time=900" rhel7_cis_pam_files
echo "even_deny_root" > "{{{ pam_faillock_conf_path }}}"
