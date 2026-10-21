#!/bin/bash
# platform = Red Hat Enterprise Linux 7

{{{ tests_init_faillock_vars("correct", prm_name=PRM_NAME, ext_variable=EXT_VARIABLE, variable_lower_bound=VARIABLE_LOWER_BOUND, variable_upper_bound=VARIABLE_UPPER_BOUND) }}}

# The CIS Benchmark writes the authfail line with [default=die].
. $SHARED/pam_rhel7.sh
FAILLOCK_ARGS="audit $PRM_NAME=$TEST_VALUE" rhel7_cis_pam_files
