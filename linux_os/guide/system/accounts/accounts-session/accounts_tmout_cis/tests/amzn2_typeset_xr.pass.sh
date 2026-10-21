#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

# Amazon Linux 2 accepts typeset -xr, which RHEL 7 fails. There the
# scenario writes the readonly and export commands.
. /etc/os-release
if [ "$ID" = amzn ]; then
    echo "typeset -xr TMOUT=900" > /etc/profile.d/tmout.sh
else
    echo "readonly TMOUT=900 ; export TMOUT" > /etc/profile.d/tmout.sh
fi
