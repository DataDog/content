#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

# RHEL 7 wants one file to set TMOUT fully and passes a bare assignment in
# another. Amazon Linux 2 wants every file to set it fully.
echo "readonly TMOUT=900 ; export TMOUT" > /etc/profile.d/tmout.sh
. /etc/os-release
if [ "$ID" = amzn ]; then
    echo "readonly TMOUT=600 ; export TMOUT" >> /etc/profile
else
    echo "TMOUT=600" >> /etc/profile
fi
