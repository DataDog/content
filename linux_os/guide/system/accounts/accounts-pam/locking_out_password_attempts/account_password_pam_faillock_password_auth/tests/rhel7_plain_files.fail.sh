#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# Plain PAM files without authconfig, as on Amazon Linux 2, lack pam_faillock.
. $SHARED/pam_rhel7.sh
rhel7_plain_pam_files
