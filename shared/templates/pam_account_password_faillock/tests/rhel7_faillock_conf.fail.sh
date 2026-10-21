#!/bin/bash
# platform = Red Hat Enterprise Linux 7

{{{ tests_init_faillock_vars("correct", prm_name=PRM_NAME, ext_variable=EXT_VARIABLE, variable_lower_bound=VARIABLE_LOWER_BOUND, variable_upper_bound=VARIABLE_UPPER_BOUND) }}}

# pam_faillock of PAM 1.1.8 reads its options from the PAM lines only.
. $SHARED/pam_rhel7.sh
FAILLOCK_ARGS="audit" rhel7_cis_pam_files
echo "$PRM_NAME = $TEST_VALUE" > "{{{ pam_faillock_conf_path }}}"
