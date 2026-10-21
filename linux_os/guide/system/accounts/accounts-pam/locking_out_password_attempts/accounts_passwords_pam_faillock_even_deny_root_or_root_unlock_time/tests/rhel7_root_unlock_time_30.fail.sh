#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_passwords_pam_faillock_root_unlock_time=60

. $SHARED/pam_rhel7.sh
FAILLOCK_ARGS="audit deny=5 unlock_time=900 root_unlock_time=30" rhel7_cis_pam_files
