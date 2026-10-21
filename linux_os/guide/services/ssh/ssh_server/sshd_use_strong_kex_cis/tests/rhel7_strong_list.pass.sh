#!/bin/bash
# packages = openssh-server
# platform = Red Hat Enterprise Linux 7

ssh-keygen -A
sed -i '/^[[:space:]]*KexAlgorithms[[:space:]]/Id' /etc/ssh/sshd_config
sed -i '1i KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512' /etc/ssh/sshd_config
