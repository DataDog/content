#!/bin/bash
# packages = crypto-policies-scripts

echo 'cipher = -*-CBC' > /etc/crypto-policies/policies/modules/TEST-NOCBC.pmod
update-crypto-policies --set DEFAULT:TEST-NOCBC
