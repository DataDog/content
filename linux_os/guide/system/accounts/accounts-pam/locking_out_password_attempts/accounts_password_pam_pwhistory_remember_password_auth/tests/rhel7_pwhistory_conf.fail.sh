#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# profiles = xccdf_org.ssgproject.content_profile_cis

# pam_pwhistory of PAM 1.1.8 reads its options from the PAM lines only.
. $SHARED/pam_rhel7.sh
PWHISTORY_ARGS="enforce_for_root try_first_pass use_authtok" rhel7_cis_pam_files
echo "remember = 24" > /etc/security/pwhistory.conf
