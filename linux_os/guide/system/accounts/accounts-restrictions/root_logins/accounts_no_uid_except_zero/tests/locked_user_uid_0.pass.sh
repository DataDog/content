#!/bin/bash
{{%- if product in ["rhel7", "ubuntu2004"] %}}
# platform = Not Applicable
{{%- else %}}
# platform = multi_platform_all
{{%- endif %}}

useradd --non-unique --uid 0 rootlocked
# configure password, otherwise user is locked
echo "rootlocked:password" | chpasswd
passwd -l rootlocked
