#!/bin/bash

# platform = multi_platform_all
# packages = sudo
# remediation = none

# sudo skips the files of /etc/sudoers.d whose names contain a "."
echo '%wheel ALL=(ALL) TYPE=sysadm_t ROLE=sysadm_r ALL' >> /etc/sudoers.d/01-complianceascode.conf
