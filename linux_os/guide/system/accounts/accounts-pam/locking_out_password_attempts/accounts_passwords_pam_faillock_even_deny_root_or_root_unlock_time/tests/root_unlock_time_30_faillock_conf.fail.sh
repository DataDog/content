#!/bin/bash
# packages = authselect
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,multi_platform_fedora
# variables = var_accounts_passwords_pam_faillock_root_unlock_time=60

authselect select sssd --force
authselect enable-feature with-faillock
> "{{{ pam_faillock_conf_path }}}"
echo "root_unlock_time = 30" >> "{{{ pam_faillock_conf_path }}}"
echo "silent" >> "{{{ pam_faillock_conf_path }}}"
