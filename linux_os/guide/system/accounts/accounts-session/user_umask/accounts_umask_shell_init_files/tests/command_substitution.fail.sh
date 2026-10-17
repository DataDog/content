#!/bin/bash
# remediation = none

sed -i '/umask/d' /etc/profile.d/*.sh
# The check fails a value that the shell computes, and the remediation
# leaves it as it is.
echo 'umask "$(cat /etc/default/umask)"' > /etc/profile.d/umask-from-file.sh
