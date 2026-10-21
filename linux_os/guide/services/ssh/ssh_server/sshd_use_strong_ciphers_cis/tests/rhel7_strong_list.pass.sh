#!/bin/bash
# packages = openssh-server
# platform = Red Hat Enterprise Linux 7

ssh-keygen -A
sed -i '/^[[:space:]]*Ciphers[[:space:]]/Id' /etc/ssh/sshd_config
sed -i '1i Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr' /etc/ssh/sshd_config
