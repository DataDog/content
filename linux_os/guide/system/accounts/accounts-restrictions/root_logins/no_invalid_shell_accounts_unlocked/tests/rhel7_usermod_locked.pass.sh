#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# usermod -L puts a ! before the password, and passwd -S reports LK.
useradd -s /sbin/nologin cac_user
echo "cac_user:simplepass" | chpasswd
usermod -L cac_user
