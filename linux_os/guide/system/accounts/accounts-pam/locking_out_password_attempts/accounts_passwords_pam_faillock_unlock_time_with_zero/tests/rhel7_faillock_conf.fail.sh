#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_passwords_pam_faillock_unlock_time=900

# pam_faillock of PAM 1.1.8 reads its options from the PAM lines only.
. $SHARED/pam_rhel7.sh
FAILLOCK_ARGS="audit deny=5 even_deny_root" rhel7_cis_pam_files
echo "unlock_time = 900" > "{{{ pam_faillock_conf_path }}}"
