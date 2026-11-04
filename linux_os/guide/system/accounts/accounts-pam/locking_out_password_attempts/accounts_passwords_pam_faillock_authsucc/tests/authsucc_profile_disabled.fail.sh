#!/bin/bash
# platform = Ubuntu 24.04
# packages = pam

{{{ bash_enable_pam_faillock_directly_in_pam_files() }}}

# pam-auth-update --disable keeps the profile disabled through later runs
# that leave it unnamed.
cat << EOF > /usr/share/pam-configs/cac_faillock_authsucc
Name: Reset the pam_faillock tally upon successful authentication
Default: yes
Priority: 0
Auth-Type: Additional
Auth:
    sufficient                      pam_faillock.so authsucc
EOF
DEBIAN_FRONTEND=noninteractive pam-auth-update --disable cac_faillock_authsucc
