#!/bin/bash
{{% if PWQUALITY_DEFAULT is none %}}
# platform = Not Applicable
{{% endif %}}
# variables = var_password_pam_{{{ VARIABLE }}}={{{ PWQUALITY_DEFAULT }}},var_password_pam_pwquality_default_compliant=true

{{% if product == "ubuntu2404" %}}
{{{ bash_pam_pwquality_enable() }}}
{{% endif %}}

sed -i "/^\s*{{{ VARIABLE }}}\s*=/d" "{{{ pwquality_path }}}"
rm -rf /etc/security/pwquality.conf.d
