#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# remediation = none

# A shell named false is no valid shell, even when /etc/shells lists it.
echo "/bin/false" >> /etc/shells
useradd -s /bin/false cac_user
echo "cac_user:simplepass" | chpasswd
