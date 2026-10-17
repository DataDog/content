#!/bin/bash
{{% if PWQUALITY_DEFAULT is none %}}
# platform = Not Applicable
{{% else %}}
{{% set unmet = PWQUALITY_DEFAULT - 1 if OPERATION == "less than or equal" else PWQUALITY_DEFAULT + 1 %}}
{{% endif %}}
# variables = var_password_pam_{{{ VARIABLE }}}={{{ unmet }}},var_password_pam_pwquality_default_compliant=true

{{% if product == "ubuntu2404" %}}
{{{ bash_pam_pwquality_enable() }}}
{{% endif %}}

sed -i "/^\s*{{{ VARIABLE }}}\s*=/d" "{{{ pwquality_path }}}"
rm -rf /etc/security/pwquality.conf.d
