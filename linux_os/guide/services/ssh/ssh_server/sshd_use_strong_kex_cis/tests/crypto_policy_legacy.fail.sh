#!/bin/bash
# packages = openssh-server,crypto-policies-scripts
# platform = multi_platform_rhel,multi_platform_almalinux,multi_platform_al

sed -i '/^[[:space:]]*CRYPTO_POLICY=/d' /etc/sysconfig/sshd 2>/dev/null || true
sed -i '/^[[:space:]]*KexAlgorithms[[:space:]]/Id' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf 2>/dev/null || true

update-crypto-policies --set LEGACY
