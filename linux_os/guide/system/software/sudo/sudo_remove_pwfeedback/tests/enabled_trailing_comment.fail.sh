#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults env_reset' > /etc/sudoers
echo 'Defaults pwfeedback # show an asterisk per character' >> /etc/sudoers
chmod 440 /etc/sudoers
