#!/bin/bash
# packages = openssh-server
# platform = Red Hat Enterprise Linux 7

ssh-keygen -A
sed -i '/^[[:space:]]*MACs[[:space:]]/Id' /etc/ssh/sshd_config
sed -i '1i MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-sha1,umac-128@openssh.com' /etc/ssh/sshd_config
