#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_passwords_pam_faillock_unlock_time=900

# Plain PAM files without authconfig, as on Amazon Linux 2, lack pam_faillock.
. $SHARED/pam_rhel7.sh
rhel7_plain_pam_files
