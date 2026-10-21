#!/bin/bash
{{#- On RHEL 7 the dictcheck remediation removes the option, which libpwquality 1.2.3 rejects. #}}
{{%- if product == "rhel7" and VARIABLE == "dictcheck" %}}
# platform = Not Applicable
{{%- endif %}}
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
