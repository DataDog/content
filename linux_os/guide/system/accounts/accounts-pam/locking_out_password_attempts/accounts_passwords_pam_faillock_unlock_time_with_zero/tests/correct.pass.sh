#!/bin/bash
# platform = Amazon Linux 2023,multi_platform_almalinux,multi_platform_fedora,multi_platform_ol,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10
# variables = var_accounts_passwords_pam_faillock_unlock_time=900
echo "unlock_time = 900" > "{{{ pam_faillock_conf_path }}}"
authselect create-profile test_profile -b sssd
authselect select "custom/test_profile" --force
authselect enable-feature with-faillock
authselect apply-changes
