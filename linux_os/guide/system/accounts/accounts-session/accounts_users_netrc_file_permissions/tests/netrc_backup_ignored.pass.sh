#!/bin/bash
# platform = Red Hat Enterprise Linux 7

USER="cac_user"
useradd -m $USER
echo "$USER" > /home/$USER/.netrc
chmod 0600 /home/$USER/.netrc
echo "$USER" > /home/$USER/.netrc.bak
chmod 0644 /home/$USER/.netrc.bak
