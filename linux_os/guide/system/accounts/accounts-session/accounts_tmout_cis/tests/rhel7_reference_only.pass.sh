#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_accounts_tmout=900

for f in /etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local; do
    [ -f "$f" ] && sed -i '/TMOUT/d' "$f"
done

# RHEL 7 passes a file that reads TMOUT without setting it. Amazon Linux 2
# fails it, so it gets none.
echo "readonly TMOUT=900 ; export TMOUT" > /etc/profile.d/tmout.sh
. /etc/os-release
if [ "$ID" != amzn ]; then
    echo '[ -n "$TMOUT" ] && echo "Idle shells exit after $TMOUT seconds"' > /etc/profile.d/tmout_notice.sh
fi
