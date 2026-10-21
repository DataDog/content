#!/bin/bash
# platform = Red Hat Enterprise Linux 7

. $SHARED/pam_rhel7.sh
UNIX_ARGS="sha512 shadow remember=5 try_first_pass use_authtok" rhel7_cis_pam_files
