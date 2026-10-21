#!/bin/bash
# platform = Ubuntu 20.04
# packages = sudo

echo "Defaults use_pty" >> /etc/sudoers
echo "Defaults env_reset, !use_pty" >> /etc/sudoers.d/disable_use_pty
