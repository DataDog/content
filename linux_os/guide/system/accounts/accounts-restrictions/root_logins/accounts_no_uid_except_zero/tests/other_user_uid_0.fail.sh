#!/bin/bash
# platform = multi_platform_all
{{%- if product in ["rhel7", "ubuntu2004"] %}}
# The remediation locks the account, which leaves it at UID 0.
# remediation = none
{{%- endif %}}
#

useradd --non-unique --uid 0 root2
# configure password, otherwise user is locked
echo "root2:password" | chpasswd
