#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults !pwfeedback' > /etc/sudoers
chmod 440 /etc/sudoers
