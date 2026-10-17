#!/bin/bash
# packages = crypto-policies-scripts

echo 'mac = -*-128*' > /etc/crypto-policies/policies/modules/NO-WEAKMAC.pmod
update-crypto-policies --set DEFAULT:NO-WEAKMAC
rm -f /etc/crypto-policies/state/CURRENT.pol
