#!/bin/bash
# packages = openssh-server
{{% if product == "rhel7" %}}
# The OpenSSH 7.4 of RHEL 7 rejects a subtractive list.
# platform = Not Applicable
{{% endif %}}

# On RHEL 8 the crypto policy on the sshd command line takes precedence
# over sshd_config. Opt out so that the line below applies.
if grep -qs '^CRYPTO_POLICY=' /etc/crypto-policies/back-ends/opensshserver.config; then
    echo 'CRYPTO_POLICY=' >> /etc/sysconfig/sshd
fi
sed -i '1i KexAlgorithms -{{{ sshd_cis_weak_kex() }}}' /etc/ssh/sshd_config
