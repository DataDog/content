#!/bin/bash
# platform = Red Hat Enterprise Linux 8
# packages = crypto-policies-scripts

# The audit script of the CIS Benchmark passes once the global cipher line lists no CBC cipher.
echo 'cipher = -*-CBC' > /etc/crypto-policies/policies/modules/TEST-NOCBC.pmod
echo 'cipher@SSH = AES-256-CBC+' > /etc/crypto-policies/policies/modules/TEST-SSHCBC.pmod
update-crypto-policies --set DEFAULT:TEST-NOCBC:TEST-SSHCBC
