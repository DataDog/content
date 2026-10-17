#!/bin/bash
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

printf '%s\n' '[ "$(id -u)" -eq 0 ] && TMOUT=1200 || TMOUT=1800' 'readonly TMOUT' 'export TMOUT' \
    > /etc/profile.d/tmout.sh
