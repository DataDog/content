#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_password_pam_dictcheck=1,var_password_pam_pwquality_default_compliant=true

sed -i '/^\s*dictcheck\s*=/d' "{{{ pwquality_path }}}"
