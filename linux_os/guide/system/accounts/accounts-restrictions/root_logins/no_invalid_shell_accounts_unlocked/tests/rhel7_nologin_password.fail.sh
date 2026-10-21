#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# remediation = none

# The nologin shell is no valid shell, so the account must be locked.
useradd -s /sbin/nologin cac_user
echo "cac_user:simplepass" | chpasswd
