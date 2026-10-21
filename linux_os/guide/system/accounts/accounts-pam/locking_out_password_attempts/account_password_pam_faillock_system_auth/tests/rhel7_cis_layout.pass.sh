#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# The CIS Benchmark writes the authfail line with [default=die].
. $SHARED/pam_rhel7.sh
rhel7_cis_pam_files
