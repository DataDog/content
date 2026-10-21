#!/bin/bash
# platform = Red Hat Enterprise Linux 7

USER="cac_user"
useradd -m $USER
echo "$USER" > /home/$USER/.netrc
chmod 0700 /home/$USER/.netrc
