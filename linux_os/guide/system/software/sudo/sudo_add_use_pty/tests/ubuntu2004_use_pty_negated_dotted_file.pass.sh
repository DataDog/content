#!/bin/bash
# platform = Ubuntu 20.04
# packages = sudo

# sudo skips the files of /etc/sudoers.d whose names contain a "."
echo "Defaults use_pty" >> /etc/sudoers
echo "Defaults !use_pty" >> /etc/sudoers.d/disable_use_pty.conf
