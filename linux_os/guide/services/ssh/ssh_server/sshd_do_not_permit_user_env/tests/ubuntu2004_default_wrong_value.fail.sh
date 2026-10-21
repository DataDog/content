#!/bin/bash
# platform = Ubuntu 20.04
# packages = openssh-server
# variables = var_sshd_default_compliant=true

for f in /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf; do
    [ -f "$f" ] || continue
    sed -i '/^[[:space:]]*PermitUserEnvironment[[:space:]]/Id' "$f"
done
echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config.d/50-test.conf
