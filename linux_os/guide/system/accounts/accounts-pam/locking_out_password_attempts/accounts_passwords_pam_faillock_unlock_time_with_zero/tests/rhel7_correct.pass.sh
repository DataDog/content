#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_passwords_pam_faillock_unlock_time=900

. $SHARED/pam_rhel7.sh
FAILLOCK_ARGS="audit deny=5 unlock_time=1800 even_deny_root" rhel7_cis_pam_files
