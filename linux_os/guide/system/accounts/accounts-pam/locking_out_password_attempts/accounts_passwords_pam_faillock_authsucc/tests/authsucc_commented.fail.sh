#!/bin/bash
# platform = multi_platform_ubuntu
# packages = pam

{{{ bash_enable_pam_faillock_directly_in_pam_files() }}}

echo "#auth     sufficient     pam_faillock.so authsucc" >> /etc/pam.d/common-auth
