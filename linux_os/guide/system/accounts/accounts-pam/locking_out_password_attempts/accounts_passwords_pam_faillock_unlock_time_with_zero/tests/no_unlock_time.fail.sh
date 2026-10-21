#!/bin/bash
# platform = Amazon Linux 2023,multi_platform_almalinux,multi_platform_fedora,multi_platform_ol,Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10
authselect create-profile test_profile -b sssd
authselect select "custom/test_profile" --force
authselect enable-feature with-faillock
authselect apply-changes
