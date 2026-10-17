#!/bin/bash
# variables = var_accounts_tmout=900
# remediation = none

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

echo "TMOUT=900" > /etc/profile.d/tmout.sh
printf "%s\n" "readonly TMOUT" "export TMOUT" > /etc/profile.d/tmout_attributes.sh
