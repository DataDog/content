#!/bin/bash
# platform = Red Hat Enterprise Linux 7

. $SHARED/pam_rhel7.sh
rhel7_cis_pam_files
sed -i --follow-symlinks '/pam_pwhistory\.so/d' /etc/pam.d/system-auth /etc/pam.d/password-auth
