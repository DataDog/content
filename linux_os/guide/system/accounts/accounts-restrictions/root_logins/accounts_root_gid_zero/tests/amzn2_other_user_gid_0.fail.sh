#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# remediation = none

# Amazon Linux 2 fails another account of group 0. RHEL 7 reads the
# group of root alone, which fails when it is not 0.
. /etc/os-release
if [ "$ID" = amzn ]; then
    useradd --gid 0 root2
else
    usermod --gid bin root
fi
