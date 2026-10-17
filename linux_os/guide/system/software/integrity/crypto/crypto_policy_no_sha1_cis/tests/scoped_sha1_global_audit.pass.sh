#!/bin/bash
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 10
# packages = crypto-policies-scripts

# The CIS Benchmarks for these products audit the global hash and sign lines only.
if [ ! -f /usr/share/crypto-policies/policies/modules/NO-SHA1.pmod ]; then
    printf '%s\n' 'hash = -SHA1' 'sign = -*-SHA1' 'sha1_in_certs = 0' \
        > /etc/crypto-policies/policies/modules/NO-SHA1.pmod
fi
echo 'hash@openssl = SHA1+' > /etc/crypto-policies/policies/modules/TEST-SCOPESHA1.pmod
update-crypto-policies --set DEFAULT:NO-SHA1:TEST-SCOPESHA1
