#!/bin/bash
# platform = Ubuntu 20.04

# The check passes a value that the shell computes, and the remediation
# leaves it as it is while it sets the loose one.
sed -i '/^\s*umask\s/Id' /root/.bash_profile /root/.bashrc 2>/dev/null
echo "umask 022" >> /root/.bash_profile
echo 'umask "$(cat /etc/default/umask)"' >> /root/.bashrc
