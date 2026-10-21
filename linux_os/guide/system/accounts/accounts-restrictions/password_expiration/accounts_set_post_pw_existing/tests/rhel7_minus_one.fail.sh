#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# variables = var_account_disable_post_pw_expiration=30

useradd cac_testuser
sed -E -i 's/^(cac_testuser:)[^:]*:([^:]*):([^:]*):([^:]*):([^:]*):[^:]*:/\1$6$exIFis0tobKRcGBk$b.UR.Z8h96FdxJ1bgA\/vhdnp0Lsm488swdILNguQX\/5qH5hdmClyYb5xk3TpELXWzr4JOiTlHfRkPsXSjMPjv0:\2:\3:\4:\5:-1:/' /etc/shadow
