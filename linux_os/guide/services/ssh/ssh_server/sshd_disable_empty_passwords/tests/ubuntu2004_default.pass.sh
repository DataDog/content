#!/bin/bash
# platform = Ubuntu 20.04
# packages = openssh-server
# variables = var_sshd_default_compliant=true

# The sshd of Ubuntu 20.04 defaults to PermitEmptyPasswords no.
for f in /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf; do
    [ -f "$f" ] || continue
    sed -i '/^[[:space:]]*PermitEmptyPasswords[[:space:]]/Id' "$f"
done
