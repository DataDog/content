#!/bin/bash
# packages = passwd
# platform = Red Hat Enterprise Linux 7

readarray -t systemaccounts < <(awk -F: '($3 > 0 && $3 < {{{ uid_min }}}) { print $1 }' /etc/passwd)
for systemaccount in "${systemaccounts[@]}"; do
    usermod -L "$systemaccount"
done
useradd -s /sbin/nologin cac_user
echo "simplepass" | passwd --stdin cac_user
usermod -L cac_user
