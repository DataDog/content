#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# Amazon Linux 2 passes a system account with the false shell, which
# RHEL 7 fails. There the account gets the nologin shell.
. /etc/os-release
if [ "$ID" = amzn ]; then
    usermod --shell /bin/false mail
else
    usermod --shell /sbin/nologin mail
fi
