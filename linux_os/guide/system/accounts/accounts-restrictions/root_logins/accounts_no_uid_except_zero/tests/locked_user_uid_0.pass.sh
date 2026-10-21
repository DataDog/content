#!/bin/bash
{{%- if product == "rhel7" %}}
# platform = Not Applicable
{{%- else %}}
# platform = multi_platform_all
{{%- endif %}}

useradd --non-unique --uid 0 rootlocked
# configure password, otherwise user is locked
echo "rootlocked:password" | chpasswd
passwd -l rootlocked
