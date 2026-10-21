#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# The sshd of RHEL 7 defaults to GSSAPIAuthentication no.
sed -i '/^[[:space:]]*GSSAPIAuthentication[[:space:]]/Id' /etc/ssh/sshd_config
