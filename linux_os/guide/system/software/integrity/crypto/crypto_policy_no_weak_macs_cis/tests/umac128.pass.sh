#!/bin/bash
# platform = Red Hat Enterprise Linux 9,AlmaLinux OS 9
# packages = crypto-policies-scripts

# DEFAULT enables UMAC-128, a strong MAC, and no 64-bit MAC.
update-crypto-policies --set DEFAULT
