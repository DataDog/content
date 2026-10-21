#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

# Amazon Linux 2 wants every file that assigns TMOUT to mark it readonly
# and exported. RHEL 7 passes the bare assignment, so it gets a value
# above the limit there.
echo "readonly TMOUT=900 ; export TMOUT" > /etc/profile.d/tmout.sh
. /etc/os-release
if [ "$ID" = amzn ]; then
    echo "TMOUT=600" >> /etc/profile
else
    echo "TMOUT=1200" >> /etc/profile
fi
