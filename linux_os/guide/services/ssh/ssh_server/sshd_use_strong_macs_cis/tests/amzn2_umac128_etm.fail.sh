#!/bin/bash
# packages = openssh-server
# platform = Red Hat Enterprise Linux 7

# CIS Amazon Linux 2 v4.0.0 5.2.15 prohibits umac-128-etm@openssh.com.
sed -i 's/^ID=.*/ID="amzn"/' /etc/os-release
ssh-keygen -A
sed -i '/^[[:space:]]*MACs[[:space:]]/Id' /etc/ssh/sshd_config
sed -i '1i MACs hmac-sha2-256,umac-128-etm@openssh.com' /etc/ssh/sshd_config
