#!/bin/bash
{{%- if product == "rhel7" %}}
# platform = Not Applicable
{{%- endif %}}
#

sed -i 's/^\([^:]*\):x:/\1:\*:/' /etc/passwd
