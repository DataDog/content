#!/bin/bash
# platform = multi_platform_ubuntu
# packages = pam

# The profiles that ansible_pam_faillock_enable writes: authsucc in the
# Primary block, after authfail.
cat << EOF > /usr/share/pam-configs/cac_faillock
Name: Enable pam_faillock to deny access
Default: yes
Priority: 0
Conflicts: faillock
Auth-Type: Primary
Auth:
    [default=die]                   pam_faillock.so authfail
    sufficient                      pam_faillock.so authsucc
EOF
cat << EOF > /usr/share/pam-configs/cac_faillock_notify
Name: Notify of failed login attempts and reset count upon success
Default: yes
Priority: 1025
Conflicts: faillock_notify
Auth-Type: Primary
Auth:
    requisite                       pam_faillock.so preauth
Account-Type: Primary
Account:
    required                        pam_faillock.so
EOF
DEBIAN_FRONTEND=noninteractive pam-auth-update
