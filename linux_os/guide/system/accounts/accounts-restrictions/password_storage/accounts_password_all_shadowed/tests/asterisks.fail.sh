#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# remediation = none

sed -i 's/^\([^:]*\):x:/\1:\*:/' /etc/passwd
