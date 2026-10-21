#!/bin/bash
# packages = openssh-server

{{% if product == "rhel7" %}}
# sshd -T needs host keys, which RHEL 7 creates when sshd starts.
ssh-keygen -A
{{% endif %}}

# On RHEL 8 the crypto policy on the sshd command line takes precedence
# over sshd_config. Opt out so that the line below applies.
if grep -qs '^CRYPTO_POLICY=' /etc/crypto-policies/back-ends/opensshserver.config; then
    echo 'CRYPTO_POLICY=' >> /etc/sysconfig/sshd
fi
sed -i '1i Ciphers +aes128-cbc' /etc/ssh/sshd_config
