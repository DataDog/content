#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# RHEL 7 fails a system account with the false shell, which Amazon
# Linux 2 passes. There the account gets the bash shell.
. /etc/os-release
if [ "$ID" = amzn ]; then
    usermod --shell /bin/bash mail
else
    usermod --shell /bin/false mail
fi
