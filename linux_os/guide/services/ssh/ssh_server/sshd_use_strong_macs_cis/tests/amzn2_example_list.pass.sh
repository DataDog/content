#!/bin/bash
# packages = openssh-server
# platform = Red Hat Enterprise Linux 7

# The example list of CIS Amazon Linux 2 v4.0.0 5.2.15 holds
# hmac-sha1-etm@openssh.com, which its audit allows.
sed -i 's/^ID=.*/ID="amzn"/' /etc/os-release
ssh-keygen -A
sed -i '/^[[:space:]]*MACs[[:space:]]/Id' /etc/ssh/sshd_config
sed -i '1i MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1' /etc/ssh/sshd_config
