#!/bin/bash
# platform = multi_platform_ubuntu
# packages = pam

{{{ bash_enable_pam_faillock_directly_in_pam_files() }}}

cat << EOF > /usr/share/pam-configs/cac_faillock_authsucc
Name: Reset the pam_faillock tally upon successful authentication
Default: yes
Priority: 0
Auth-Type: Additional
Auth:
    sufficient                      pam_faillock.so authsucc
EOF
DEBIAN_FRONTEND=noninteractive pam-auth-update --enable cac_faillock_authsucc
