#!/bin/bash
# platform = Red Hat Enterprise Linux 9,AlmaLinux OS 9
# packages = crypto-policies-scripts

# DEFAULT keeps SHA-1 for the rpm scope only.
update-crypto-policies --set DEFAULT
