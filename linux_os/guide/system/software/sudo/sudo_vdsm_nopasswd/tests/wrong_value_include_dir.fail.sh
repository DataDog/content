#!/bin/bash
# packages = sudo
# remediation = none
echo "%wheel	ALL=(ALL)	ALL" > /etc/sudoers
echo "#includedir /etc/sudoers.d" >> /etc/sudoers
chmod 440 /etc/sudoers

mkdir -p /etc/sudoers.d
echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/sudoers
