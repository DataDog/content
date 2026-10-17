#!/bin/bash
# packages = crypto-policies-scripts

echo 'cipher@SSH = AES-256-CBC+' > /etc/crypto-policies/policies/modules/TEST-SSHCBC.pmod
update-crypto-policies --set DEFAULT:TEST-SSHCBC
