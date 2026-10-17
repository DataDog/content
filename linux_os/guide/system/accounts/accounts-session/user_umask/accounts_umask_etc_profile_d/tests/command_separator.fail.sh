#!/bin/bash
# variables = var_accounts_user_umask=027

for f in /etc/profile.d/*.sh; do
    [ -f "$f" ] && sed -i -E '/^\s*umask\s/Id' "$f"
done

echo "umask 022; export FOO=bar" > /etc/profile.d/60-default_umask.sh
echo "umask 027&& export BAR=baz" > /etc/profile.d/zz-umask.sh
