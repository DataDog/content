#!/bin/bash
# platform = Red Hat Enterprise Linux 9,AlmaLinux OS 9
# packages = crypto-policies-scripts

echo 'mac@SSH = UMAC-64+' > /etc/crypto-policies/policies/modules/TEST-SSHUMAC64.pmod
update-crypto-policies --set DEFAULT:TEST-SSHUMAC64
