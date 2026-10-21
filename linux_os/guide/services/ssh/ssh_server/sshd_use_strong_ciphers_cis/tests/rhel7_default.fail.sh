#!/bin/bash
# packages = openssh-server
# platform = Red Hat Enterprise Linux 7

# The defaults of the OpenSSH 7.4 of RHEL 7 offer algorithms that the
# benchmark prohibits.
ssh-keygen -A
sed -i '/^[[:space:]]*Ciphers[[:space:]]/Id' /etc/ssh/sshd_config
