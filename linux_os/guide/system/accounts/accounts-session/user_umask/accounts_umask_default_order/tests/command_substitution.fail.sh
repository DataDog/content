#!/bin/bash
# platform = multi_platform_ubuntu
# remediation = none
# variables = var_accounts_user_umask=027

# Start with no umask setting in the locations the rule reads.
for f in /etc/profile.d/*.sh /etc/profile /etc/bashrc /etc/bash.bashrc /etc/login.defs /etc/default/login; do
    [ -f "$f" ] || continue
    sed -i '/^\s*umask\s/Id' "$f"
done

# The check fails a value that the shell computes, and the remediation
# leaves it as it is.
echo 'umask "$(cat /etc/default/umask)"' > /etc/profile.d/50-systemwide_umask.sh
