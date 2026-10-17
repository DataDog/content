#!/bin/bash

# su starts root from ENV_SUPATH when /etc/environment sets no PATH, and
# ENV_SUPATH takes precedence over ENV_ROOTPATH.
sed -i '/^[[:space:]]*PATH[[:space:]]*=/d' /etc/environment 2>/dev/null
sed -i '/^[[:space:]]*ENV_\(SU\|ROOT\)PATH[[:space:]]/d' /etc/login.defs
rm -rf /nonexistent-supath
echo 'ENV_ROOTPATH PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin' >>/etc/login.defs
echo 'ENV_SUPATH PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/nonexistent-supath' >>/etc/login.defs
printf 'export PATH\n' >/root/.bash_profile
