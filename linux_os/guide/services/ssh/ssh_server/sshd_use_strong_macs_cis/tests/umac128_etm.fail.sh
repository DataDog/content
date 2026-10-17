#!/bin/bash
# packages = openssh-server
# platform = multi_platform_ubuntu,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 10,Amazon Linux 2023

# On RHEL 8 the crypto policy on the sshd command line takes precedence
# over sshd_config. Opt out so that the line below applies.
if grep -qs '^CRYPTO_POLICY=' /etc/crypto-policies/back-ends/opensshserver.config; then
    echo 'CRYPTO_POLICY=' >> /etc/sysconfig/sshd
fi
sed -i '1i MACs hmac-sha2-256,umac-128-etm@openssh.com' /etc/ssh/sshd_config
