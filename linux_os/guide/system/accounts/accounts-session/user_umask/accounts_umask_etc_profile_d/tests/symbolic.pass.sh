#!/bin/bash
# variables = var_accounts_user_umask=027

for f in /etc/profile.d/*.sh; do
    [ -f "$f" ] && sed -i -E '/^\s*umask\s/Id' "$f"
done

echo "umask u=rwx,g=rx,o=" > /etc/profile.d/60-default_umask.sh
