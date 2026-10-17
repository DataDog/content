#!/bin/bash
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 10,multi_platform_ubuntu
# variables = var_accounts_tmout=900
# remediation = none

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

echo "readonly TMOUT=900 ; export TMOUT" > /etc/profile.d/tmout.sh
echo '[ -n "$TMOUT" ] && echo "Idle shells exit after $TMOUT seconds"' > /etc/profile.d/tmout_notice.sh
