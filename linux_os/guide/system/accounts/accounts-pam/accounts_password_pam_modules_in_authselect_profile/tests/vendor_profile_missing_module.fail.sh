#!/bin/bash
# platform = multi_platform_all

# authselect takes a vendor profile in place of the default profile with the
# same ID.
mkdir -p /usr/share/authselect/vendor
cp -a /usr/share/authselect/default/sssd /usr/share/authselect/vendor/sssd
sed -i '/pam_pwhistory\.so/d' /usr/share/authselect/vendor/sssd/system-auth /usr/share/authselect/vendor/sssd/password-auth
authselect select sssd --force
authselect apply-changes
