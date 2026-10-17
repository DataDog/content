#!/bin/bash
# packages = openssh-server,crypto-policies-scripts
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 10,Amazon Linux 2023

sed -i '/^[[:space:]]*CRYPTO_POLICY=/d' /etc/sysconfig/sshd 2>/dev/null || true
sed -i '/^[[:space:]]*MACs[[:space:]]/Id' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf 2>/dev/null || true

update-crypto-policies --set DEFAULT
