#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# pam_pwhistory of PAM 1.1.8 reads its options from the PAM lines only.
. $SHARED/pam_rhel7.sh
PWHISTORY_ARGS="remember=24 try_first_pass use_authtok" rhel7_cis_pam_files
echo "enforce_for_root" > /etc/security/pwhistory.conf
