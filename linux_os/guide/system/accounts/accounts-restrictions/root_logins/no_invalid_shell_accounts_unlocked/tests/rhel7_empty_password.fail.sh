#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# remediation = none

# passwd -S reports NP for an empty password.
useradd -s /sbin/nologin cac_user
sed -i 's/^cac_user:[^:]*:/cac_user::/' /etc/shadow
