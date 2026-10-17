#!/bin/bash
# remediation = none

useradd -m testuser_dot
touch /home/testuser_dot/.bash_history
chmod 0644 /home/testuser_dot/.bash_history
