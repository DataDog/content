#!/bin/bash
# packages = openssh-server,crypto-policies-scripts
# platform = Red Hat Enterprise Linux 10

# The remediation appends its line to a module whose last line is a
# comment without a newline.
sed -i '/^[[:space:]]*CRYPTO_POLICY=/d' /etc/sysconfig/sshd 2>/dev/null || true
sed -i '/^[[:space:]]*MACs[[:space:]]/Id' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf 2>/dev/null || true

mkdir -p /etc/crypto-policies/policies/modules
printf '%s' '# Site MAC settings' > /etc/crypto-policies/policies/modules/NO-SSHWEAKMACS.pmod
update-crypto-policies --set DEFAULT
