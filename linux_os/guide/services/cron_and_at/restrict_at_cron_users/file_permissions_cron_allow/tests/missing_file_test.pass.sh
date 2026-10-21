#!/bin/bash
{{%- if 'debian' in product or 'ubuntu' in product %}}
# packages = cron
{{%- else %}}
# packages = crontabs
{{%- endif %}}

rm -f /etc/cron.allow
