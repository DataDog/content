#!/bin/bash
# packages = openssh-server
# platform = Red Hat Enterprise Linux 7,multi_platform_ubuntu,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 10,Amazon Linux 2023

{{% if product == "rhel7" %}}
# sshd -T needs host keys, which RHEL 7 creates when sshd starts.
ssh-keygen -A
{{% endif %}}

# On RHEL 8 the crypto policy on the sshd command line takes precedence
# over sshd_config. Opt out so that the line below applies.
if grep -qs '^CRYPTO_POLICY=' /etc/crypto-policies/back-ends/opensshserver.config; then
    echo 'CRYPTO_POLICY=' >> /etc/sysconfig/sshd
fi
sed -i '1i MACs hmac-sha2-256,umac-128-etm@openssh.com' /etc/ssh/sshd_config
