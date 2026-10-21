#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# The CIS RHEL 7 audit requires every account with the nologin shell to be locked.
useradd -s /sbin/nologin cac_user
echo "simplepass" | passwd --stdin cac_user
