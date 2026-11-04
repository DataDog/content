#!/bin/bash
# platform = multi_platform_ubuntu
# packages = pam

rm -f /usr/share/pam-configs/cac_faillock /usr/share/pam-configs/cac_faillock_notify /usr/share/pam-configs/cac_faillock_authsucc
DEBIAN_FRONTEND=noninteractive pam-auth-update
