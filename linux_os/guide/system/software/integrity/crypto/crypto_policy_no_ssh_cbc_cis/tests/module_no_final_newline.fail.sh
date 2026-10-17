#!/bin/bash
# packages = crypto-policies-scripts

# The remediation appends its line to a module whose last line has no
# newline.
printf '%s' 'cipher@SSH = -3DES-CBC' > /etc/crypto-policies/policies/modules/NO-SSHCBC.pmod
echo 'cipher@SSH = AES-256-CBC+' > /etc/crypto-policies/policies/modules/TEST-SSHCBC.pmod
update-crypto-policies --set DEFAULT:TEST-SSHCBC
