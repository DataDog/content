#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_passwords_pam_faillock_root_unlock_time=60

. $SHARED/pam_rhel7.sh
rhel7_cis_pam_files
