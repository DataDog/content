#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# The RHEL 7 STIG enables pam_pwquality.so as required.
. $SHARED/pam_rhel7.sh
rhel7_cis_pam_files
sed -i --follow-symlinks 's/^password\s\+requisite\s\+pam_pwquality\.so.*/password    required      pam_pwquality.so retry=3/' /etc/pam.d/system-auth /etc/pam.d/password-auth
