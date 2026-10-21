#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# useradd -r gives out SYS_UID_MAX, 999, first. The CIS RHEL 7 audit reads every account below UID_MIN.
useradd -r -u 999 -s /bin/bash cac_sysuser
