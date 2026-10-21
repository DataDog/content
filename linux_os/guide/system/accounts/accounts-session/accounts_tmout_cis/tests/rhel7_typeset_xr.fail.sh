#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

# RHEL 7 fails typeset -xr, which Amazon Linux 2 accepts. There the
# scenario leaves out the r, which both audits fail.
. /etc/os-release
if [ "$ID" = amzn ]; then
    echo "typeset -x TMOUT=900" > /etc/profile.d/tmout.sh
else
    echo "typeset -xr TMOUT=900" > /etc/profile.d/tmout.sh
fi
