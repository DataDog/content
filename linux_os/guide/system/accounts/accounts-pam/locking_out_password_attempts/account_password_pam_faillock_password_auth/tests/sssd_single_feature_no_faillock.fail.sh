#!/bin/bash
# packages = authselect,pam
# platform = Oracle Linux 8,Oracle Linux 9,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,multi_platform_fedora

# Test with sssd profile and one feature (not faillock) enabled
# This simulates a system where "authselect current --raw" returns "sssd with-fingerprint"
authselect select sssd --force
authselect enable-feature with-fingerprint

authselect apply-changes
