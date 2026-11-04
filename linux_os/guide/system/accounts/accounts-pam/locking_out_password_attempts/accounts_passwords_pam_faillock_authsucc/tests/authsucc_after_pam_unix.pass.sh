#!/bin/bash
# platform = multi_platform_ubuntu
# packages = pam

# The lines that the STIG fix text adds below pam_unix.so in common-auth.
sed -i --follow-symlinks '/^auth.*pam_unix\.so/a auth     sufficient     pam_faillock.so authsucc' /etc/pam.d/common-auth
sed -i --follow-symlinks '/^auth.*pam_unix\.so/a auth     [default=die]  pam_faillock.so authfail' /etc/pam.d/common-auth
