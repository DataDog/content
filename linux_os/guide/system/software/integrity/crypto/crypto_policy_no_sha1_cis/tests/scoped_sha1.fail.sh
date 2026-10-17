#!/bin/bash
# platform = Red Hat Enterprise Linux 9,AlmaLinux OS 9
# packages = crypto-policies-scripts

echo 'hash@openssl = SHA1+' > /etc/crypto-policies/policies/modules/TEST-SCOPESHA1.pmod
update-crypto-policies --set DEFAULT:NO-SHA1:TEST-SCOPESHA1
