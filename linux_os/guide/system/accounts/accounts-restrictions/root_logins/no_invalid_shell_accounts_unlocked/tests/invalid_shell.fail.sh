#!/bin/bash
# remediation = none

echo "newuser:x:8000:8000:newuser:/home/newuser:/bin/invalid_shell" >> /etc/passwd
echo 'newuser:$6$exIFis0tobKRcGBk$b.UR.Z8h96FdxJ1bgA/vhdnp0Lsm488swdILNguQX/5qH5hdmClyYb5xk3TpELXWzr4JOiTlHfRkPsXSjMPjv0:20111:0:99999:7:::' >> /etc/shadow
echo "/bin/someothershell" > /etc/shells
