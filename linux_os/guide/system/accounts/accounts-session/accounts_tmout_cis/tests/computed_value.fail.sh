#!/bin/bash
# remediation = none
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

# The check fails a value that the shell computes, and the remediation
# leaves it as it is.
echo 'readonly TMOUT="$((60 * 15))"; export TMOUT' > /etc/profile.d/tmout.sh
