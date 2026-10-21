#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_tmout=900
# remediation = none

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

# Amazon Linux 2 fails a file that reads TMOUT without setting it. RHEL 7
# passes it, so the assignment is left out there.
. /etc/os-release
if [ "$ID" = amzn ]; then
    echo "readonly TMOUT=900 ; export TMOUT" > /etc/profile.d/tmout.sh
fi
echo '[ -n "$TMOUT" ] && echo "Idle shells exit after $TMOUT seconds"' > /etc/profile.d/tmout_notice.sh
