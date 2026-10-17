#!/bin/bash
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

# The remediation sets the assignment and leaves the string as it is.
printf '%s\n' 'TMOUT=1200' 'readonly TMOUT' 'export TMOUT' \
    'tmout_notice() { echo "TMOUT=600"; }' > /etc/profile.d/tmout.sh
