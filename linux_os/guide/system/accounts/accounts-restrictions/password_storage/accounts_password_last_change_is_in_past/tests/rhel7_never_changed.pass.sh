#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# An empty last change field reads as never in chage, which the CIS RHEL 7 audit passes.
echo 'testuser:$6$exIFis0tobKRcGBk$b.UR.Z8h96FdxJ1bgA/vhdnp0Lsm488swdILNguQX/5qH5hdmClyYb5xk3TpELXWzr4JOiTlHfRkPsXSjMPjv0::1:60:7:35::' >> /etc/shadow
