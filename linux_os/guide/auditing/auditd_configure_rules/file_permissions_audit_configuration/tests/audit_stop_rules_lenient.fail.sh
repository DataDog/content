#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

find /etc/audit -type f \( -name '*.conf' -o -name '*.rules' \) -exec chmod u-x,g-wx,o-rwx {} +
touch /etc/audit/audit-stop.rules
chmod 0644 /etc/audit/audit-stop.rules
