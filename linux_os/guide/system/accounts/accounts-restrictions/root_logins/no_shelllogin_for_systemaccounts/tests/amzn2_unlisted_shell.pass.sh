#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# Amazon Linux 2 passes a system account with a shell that /etc/shells
# leaves out, which RHEL 7 fails. There the account gets the nologin
# shell.
. /etc/os-release
if [ "$ID" = amzn ]; then
    sed -i '/^\/bin\/sh$/d' /etc/shells
    usermod --shell /bin/sh mail
else
    usermod --shell /sbin/nologin mail
fi
