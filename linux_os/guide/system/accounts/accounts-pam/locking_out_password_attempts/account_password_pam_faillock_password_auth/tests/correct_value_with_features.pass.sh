#!/bin/bash
# packages = authselect,pam
# platform = Oracle Linux 8,Oracle Linux 9,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,multi_platform_fedora

authselect create-profile test_profile -b sssd
authselect select "custom/test_profile" --force

# Enable multiple features to test the scenario where "authselect current --raw"
# returns a string with spaces (e.g., "custom/test_profile with-faillock with-fingerprint")
authselect enable-feature with-faillock
authselect enable-feature with-fingerprint

authselect apply-changes
