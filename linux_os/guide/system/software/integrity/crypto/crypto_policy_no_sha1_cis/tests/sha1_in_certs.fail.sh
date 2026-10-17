#!/bin/bash
# packages = crypto-policies-scripts

if [ ! -f /usr/share/crypto-policies/policies/modules/NO-SHA1.pmod ]; then
    printf '%s\n' 'hash = -SHA1' 'sign = -*-SHA1' 'sha1_in_certs = 0' \
        > /etc/crypto-policies/policies/modules/NO-SHA1.pmod
fi
echo 'sha1_in_certs = 1' > /etc/crypto-policies/policies/modules/TEST-SHA1CERTS.pmod
update-crypto-policies --set DEFAULT:NO-SHA1:TEST-SHA1CERTS
