#!/bin/bash
# platform = Red Hat Enterprise Linux 7

. $SHARED/pam_rhel7.sh
rhel7_cis_pam_files
sed -i --follow-symlinks 's/\(pam_pwhistory\.so.*\) enforce_for_root/\1/' /etc/pam.d/password-auth
