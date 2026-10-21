#!/bin/bash
# platform = Red Hat Enterprise Linux 7
sed -i 's/use_authtok/remember/' /etc/pam.d/system-auth /etc/pam.d/password-auth
