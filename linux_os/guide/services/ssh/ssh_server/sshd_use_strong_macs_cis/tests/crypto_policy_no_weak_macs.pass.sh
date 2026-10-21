#!/bin/bash
# packages = openssh-server,crypto-policies-scripts
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,multi_platform_almalinux,multi_platform_al

sed -i '/^[[:space:]]*CRYPTO_POLICY=/d' /etc/sysconfig/sshd 2>/dev/null || true
sed -i '/^[[:space:]]*MACs[[:space:]]/Id' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf 2>/dev/null || true

mkdir -p /etc/crypto-policies/policies/modules
echo 'mac@SSH = -HMAC-MD5* -UMAC-64* -UMAC-128* -HMAC-SHA1*' > /etc/crypto-policies/policies/modules/NO-SSHWEAKMACS.pmod
update-crypto-policies --set DEFAULT:NO-SSHWEAKMACS
