#!/bin/bash
# packages = crypto-policies-scripts

echo 'mac = UMAC-64+' > /etc/crypto-policies/policies/modules/TEST-UMAC64.pmod
update-crypto-policies --set DEFAULT:TEST-UMAC64
