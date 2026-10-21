#!/bin/bash
# packages = authselect,pam
# platform = Oracle Linux 8,Oracle Linux 9,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,multi_platform_fedora

authselect create-profile test_profile -b sssd
authselect select "custom/test_profile" --force

# Enable other features but not with-faillock to simulate a system
# that has authselect configured with features, but missing the required faillock
authselect enable-feature with-fingerprint
authselect enable-feature with-silent-lastlog

authselect apply-changes
