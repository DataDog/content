#!/bin/bash
# platform = Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,AlmaLinux OS 9
# packages = crypto-policies-scripts

echo 'cipher = -*-CBC' > /etc/crypto-policies/policies/modules/TEST-NOCBC.pmod
echo 'cipher@SSH = AES-256-CBC+' > /etc/crypto-policies/policies/modules/TEST-SSHCBC.pmod
update-crypto-policies --set DEFAULT:TEST-NOCBC:TEST-SSHCBC
