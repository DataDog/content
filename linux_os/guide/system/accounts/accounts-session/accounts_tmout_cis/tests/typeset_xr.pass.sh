#!/bin/bash
# platform = multi_platform_rhel,multi_platform_almalinux,multi_platform_ubuntu
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

echo "typeset -xr TMOUT=900" > /etc/profile.d/tmout.sh
