#!/bin/bash
# packages = crypto-policies-scripts

printf '%s\n' 'hash = SHA1+' 'sign = RSA-SHA1+' > /etc/crypto-policies/policies/modules/TEST-SHA1.pmod
update-crypto-policies --set DEFAULT:TEST-SHA1
