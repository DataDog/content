#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults env_reset' > /etc/sudoers
echo 'Defaults logfile=/var/log/sudo.log,pwfeedback' >> /etc/sudoers
chmod 440 /etc/sudoers
