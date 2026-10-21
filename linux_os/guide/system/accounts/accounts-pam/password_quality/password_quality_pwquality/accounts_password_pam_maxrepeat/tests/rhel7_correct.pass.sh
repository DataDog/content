#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_password_pam_maxrepeat=3

sed -i '/^\s*maxrepeat\s*=/d' "{{{ pwquality_path }}}"
echo "maxrepeat = 3" >> "{{{ pwquality_path }}}"
