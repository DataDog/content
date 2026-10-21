#!/bin/bash
# platform = Ubuntu 20.04
# variables = var_account_disable_post_pw_expiration=30
# remediation = none

# shadow rejects a negative INACTIVE, so chage appends a second entry and
# the line stays for the administrator to repair.
TEST_USER="cac_testuser"
useradd $TEST_USER
sed -E -i "s/($TEST_USER:)(.*)/\1\$6\$exIFis0tobKRcGBk\$b.UR.Z8h96FdxJ1bgA\/vhdnp0Lsm488swdILNguQX\/5qH5hdmClyYb5xk3TpELXWzr4JOiTlHfRkPsXSjMPjv0:19396:1:60:7:-1::/" /etc/shadow
