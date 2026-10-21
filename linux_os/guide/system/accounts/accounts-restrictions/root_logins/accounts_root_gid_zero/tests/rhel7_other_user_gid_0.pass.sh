#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# RHEL 7 reads the group of root alone. Amazon Linux 2 fails another
# account of group 0, so it gets none.
. /etc/os-release
if [ "$ID" != amzn ]; then
    useradd --gid 0 root2
fi
