#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults env_reset' > /etc/sudoers
# sudo reads the text after the "#" as a comment.
echo 'Defaults logfile=/var/log/sudo.log,!visiblepw # disable visiblepw' >> /etc/sudoers
chmod 440 /etc/sudoers
