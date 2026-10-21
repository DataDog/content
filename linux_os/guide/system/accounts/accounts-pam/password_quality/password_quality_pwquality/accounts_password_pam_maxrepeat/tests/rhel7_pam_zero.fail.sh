#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_password_pam_maxrepeat=3

sed -i '/^\s*maxrepeat\s*=/d' "{{{ pwquality_path }}}"
echo "maxrepeat = 3" >> "{{{ pwquality_path }}}"
. $SHARED/pam_rhel7.sh
PWQUALITY_ARGS="try_first_pass local_users_only retry=3 maxrepeat=0" rhel7_cis_pam_files
