#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# The sshd of RHEL 7 defaults to PermitEmptyPasswords no.
sed -i '/^[[:space:]]*PermitEmptyPasswords[[:space:]]/Id' /etc/ssh/sshd_config
