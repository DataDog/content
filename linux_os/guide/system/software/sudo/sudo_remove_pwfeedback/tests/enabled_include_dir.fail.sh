#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults env_reset' > /etc/sudoers
chmod 440 /etc/sudoers
mkdir -p /etc/sudoers.d
echo 'Defaults pwfeedback' > /etc/sudoers.d/cis
chmod 440 /etc/sudoers.d/cis
