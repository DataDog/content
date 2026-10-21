#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

find /etc/audit -type f \( -name '*.conf' -o -name '*.rules' \) -exec chgrp root {} +
touch /etc/audit/audit-stop.rules
groupadd testgroup_123
chgrp testgroup_123 /etc/audit/audit-stop.rules
