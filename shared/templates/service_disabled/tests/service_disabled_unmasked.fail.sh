#!/bin/bash
# packages = {{{ PACKAGENAME }}}

SYSTEMCTL_EXEC='/usr/bin/systemctl'
if "$SYSTEMCTL_EXEC" -q list-unit-files '{{{ DAEMONNAME }}}.service'; then
    "$SYSTEMCTL_EXEC" unmask '{{{ DAEMONNAME }}}.service'
    "$SYSTEMCTL_EXEC" stop '{{{ DAEMONNAME }}}.service'
    "$SYSTEMCTL_EXEC" disable '{{{ DAEMONNAME }}}.service'
fi
if "$SYSTEMCTL_EXEC" -q list-unit-files '{{{ DAEMONNAME }}}.socket'; then
    "$SYSTEMCTL_EXEC" unmask '{{{ DAEMONNAME }}}.socket'
    "$SYSTEMCTL_EXEC" stop '{{{ DAEMONNAME }}}.socket'
    "$SYSTEMCTL_EXEC" disable '{{{ DAEMONNAME }}}.socket'
fi
"$SYSTEMCTL_EXEC" reset-failed '{{{ DAEMONNAME }}}.service' || true
