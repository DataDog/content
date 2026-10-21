#!/bin/bash
# packages = audit
# platform = Red Hat Enterprise Linux 7

find /etc/audit -type f \( -name '*.conf' -o -name '*.rules' \) -exec chown root {} +
touch /etc/audit/audit-stop.rules
useradd testuser_123
chown testuser_123 /etc/audit/audit-stop.rules
