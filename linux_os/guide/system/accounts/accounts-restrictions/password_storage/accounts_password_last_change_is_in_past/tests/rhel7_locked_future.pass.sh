#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# The CIS RHEL 7 audit skips a password field that starts with !, as a locked password does.
TOMORROW="$(( $(date +%s) / 86400 + 1 ))"
echo "testuser:!\$6\$exIFis0tobKRcGBk\$b.UR.Z8h96FdxJ1bgA/vhdnp0Lsm488swdILNguQX/5qH5hdmClyYb5xk3TpELXWzr4JOiTlHfRkPsXSjMPjv0:$TOMORROW:1:60:7:35::" >> /etc/shadow
