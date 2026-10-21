#!/bin/bash
# platform = Red Hat Enterprise Linux 7

. $SHARED/pam_rhel7.sh
rhel7_cis_pam_files
sed -i --follow-symlinks 's/^\(password\s\+sufficient\s\+pam_unix\.so.*\)$/\1 remember=5/' /etc/pam.d/system-auth
