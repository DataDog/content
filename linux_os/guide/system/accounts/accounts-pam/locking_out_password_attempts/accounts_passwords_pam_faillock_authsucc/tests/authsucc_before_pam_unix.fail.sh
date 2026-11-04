#!/bin/bash
# platform = multi_platform_ubuntu
# packages = pam
# remediation = none

# pam-auth-update leaves a common-auth with local modifications alone.
{{{ bash_enable_pam_faillock_directly_in_pam_files() }}}
sed -i --follow-symlinks '/^auth.*pam_unix\.so/i auth     sufficient     pam_faillock.so authsucc' /etc/pam.d/common-auth
sed -i --follow-symlinks '/^auth.*pam_faillock\.so.*authfail/a auth     sufficient     pam_faillock.so authsucc' /etc/pam.d/common-auth
