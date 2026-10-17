#!/bin/bash
# variables = var_accounts_user_umask=027

readarray -t profile_d_scripts < <(find /etc/profile.d/ -type f -name '*.sh' 2>/dev/null)
for f in /etc/profile /etc/bashrc /etc/bash.bashrc /etc/profile.d/sh.local "${profile_d_scripts[@]}"; do
    [ -f "$f" ] && sed -i -E 's/^(\s*)umask\s.*/\1:/I' "$f"
done

echo "umask 002" >> /etc/profile.d/sh.local
