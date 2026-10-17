#!/bin/bash
# packages = crypto-policies-scripts

echo 'cipher@SSH = -*-CBC' > /etc/crypto-policies/policies/modules/NO-SSHCBC.pmod
update-crypto-policies --set DEFAULT:NO-SSHCBC
