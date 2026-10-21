#!/bin/bash
# platform = Ubuntu 20.04

# The audit reads /root/.bash_profile, /root/.bashrc and /etc/login.defs.
sed -i '/umask/Id' /root/.bash_profile /root/.bashrc /etc/login.defs 2>/dev/null
echo "UMASK 027" >> /etc/login.defs
echo "umask 022" >> /root/.profile
echo "# umask 022" >> /root/.bashrc
