#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# The sshd of RHEL 7 defaults to IgnoreRhosts yes.
sed -i '/^[[:space:]]*IgnoreRhosts[[:space:]]/Id' /etc/ssh/sshd_config
