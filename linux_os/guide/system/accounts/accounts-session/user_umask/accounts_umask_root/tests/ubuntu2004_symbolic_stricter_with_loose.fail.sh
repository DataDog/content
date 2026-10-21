#!/bin/bash
# platform = Ubuntu 20.04

# A loose value, and a symbolic one stricter than 027 that the
# remediation keeps.
sed -i '/^\s*umask\s/Id' /root/.bash_profile /root/.bashrc 2>/dev/null
echo "umask 022" >> /root/.bash_profile
echo "umask u=rwx,g=,o=" >> /root/.bashrc
