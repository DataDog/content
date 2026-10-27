#!/bin/bash
# platform = multi_platform_ubuntu
# packages = pam

# An existing cac_pwhistory profile with inline Password and
# Password-Initial entries, both without use_authtok. Its priority puts
# pam_pwhistory after pam_unix, so its Password entry applies.
config_file=/usr/share/pam-configs/cac_pwhistory

cat << EOF > "$config_file"
Name: pwhistory password history checking
Default: yes
Priority: 100
Password-Type: Primary
Password: requisite pam_pwhistory.so remember=24 enforce_for_root try_first_pass
Password-Initial: requisite pam_pwhistory.so remember=24 enforce_for_root try_first_pass
EOF

DEBIAN_FRONTEND=noninteractive pam-auth-update --enable cac_pwhistory
