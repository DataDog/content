#!/bin/bash
# platform = multi_platform_all
{{%- if product == "rhel7" %}}
# The remediation locks the account, which leaves it at UID 0.
# remediation = none
{{%- endif %}}
#

useradd --non-unique --uid 0 root2
# configure password, otherwise user is locked
echo "root2:password" | chpasswd
