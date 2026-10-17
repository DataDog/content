#!/bin/bash
# variables = var_accounts_tmout=600

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

echo "readonly TMOUT=900 ; export TMOUT" > /etc/profile.d/tmout.sh
