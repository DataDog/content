#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_password_pam_maxrepeat=3

# A maxrepeat of 0 turns the check off.
sed -i '/^\s*maxrepeat\s*=/d' "{{{ pwquality_path }}}"
echo "maxrepeat = 0" >> "{{{ pwquality_path }}}"
