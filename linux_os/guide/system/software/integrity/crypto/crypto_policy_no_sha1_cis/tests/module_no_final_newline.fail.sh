#!/bin/bash
# packages = crypto-policies-scripts

# The remediation appends its lines to a module whose last line has no
# newline.
printf '%s' 'hash = -SHA1' > /etc/crypto-policies/policies/modules/NO-SHA1.pmod
echo 'sha1_in_certs = 1' > /etc/crypto-policies/policies/modules/TEST-SHA1CERTS.pmod
update-crypto-policies --set DEFAULT:TEST-SHA1CERTS
