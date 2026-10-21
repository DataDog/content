#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# remediation = none

useradd --non-unique --uid 0 rootlocked
# configure password, otherwise user is locked
echo "rootlocked:password" | chpasswd
passwd -l rootlocked
