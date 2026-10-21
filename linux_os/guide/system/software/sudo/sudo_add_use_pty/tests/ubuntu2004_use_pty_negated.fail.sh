#!/bin/bash
# platform = Ubuntu 20.04
# packages = sudo

# The audit fails a Defaults !use_pty entry beside Defaults use_pty.
echo "Defaults use_pty" >> /etc/sudoers
echo "Defaults !use_pty" >> /etc/sudoers.d/disable_use_pty
