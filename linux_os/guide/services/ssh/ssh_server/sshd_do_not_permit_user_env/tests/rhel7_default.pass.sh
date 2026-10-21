#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# The sshd of RHEL 7 defaults to PermitUserEnvironment no.
sed -i '/^[[:space:]]*PermitUserEnvironment[[:space:]]/Id' /etc/ssh/sshd_config
