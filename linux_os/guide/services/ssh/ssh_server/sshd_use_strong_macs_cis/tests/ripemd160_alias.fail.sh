#!/bin/bash
# packages = openssh-server
# platform = Red Hat Enterprise Linux 7

# The audits match hmac-ripemd160 between word boundaries, which takes in
# the hmac-ripemd160@openssh.com alias of OpenSSH 7.4.
ssh-keygen -A
sed -i '/^[[:space:]]*MACs[[:space:]]/Id' /etc/ssh/sshd_config
sed -i '1i MACs hmac-sha2-256,hmac-ripemd160@openssh.com' /etc/ssh/sshd_config
