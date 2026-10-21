#!/bin/bash

touch /etc/cron.allow
{{%- if "ubuntu" in product %}}
getent group crontab >/dev/null || groupadd crontab
chgrp crontab /etc/cron.allow
{{%- else %}}
chgrp root /etc/cron.allow
{{%- endif %}}
