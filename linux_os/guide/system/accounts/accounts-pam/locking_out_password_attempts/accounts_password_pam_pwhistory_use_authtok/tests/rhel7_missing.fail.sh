#!/bin/bash
# platform = Red Hat Enterprise Linux 7

. $SHARED/pam_rhel7.sh
PWHISTORY_ARGS="remember=24 enforce_for_root try_first_pass" rhel7_cis_pam_files
