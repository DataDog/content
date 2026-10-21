#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_password_pam_dictcheck=1,var_password_pam_pwquality_default_compliant=true

sed -i '/^\s*dictcheck\s*=/d' "{{{ pwquality_path }}}"
. $SHARED/pam_rhel7.sh
PWQUALITY_ARGS="try_first_pass local_users_only retry=3 dictcheck=0" rhel7_cis_pam_files
