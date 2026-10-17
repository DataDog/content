#!/bin/bash
# packages = crypto-policies-scripts

if [ ! -f /usr/share/crypto-policies/policies/modules/NO-SHA1.pmod ]; then
    printf '%s\n' 'hash = -SHA1' 'sign = -*-SHA1' 'sha1_in_certs = 0' \
        > /etc/crypto-policies/policies/modules/NO-SHA1.pmod
fi
update-crypto-policies --set DEFAULT:NO-SHA1
