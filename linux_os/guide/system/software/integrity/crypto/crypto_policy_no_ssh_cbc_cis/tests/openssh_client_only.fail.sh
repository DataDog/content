#!/bin/bash
# packages = crypto-policies-scripts

# Only the OpenSSH client gets a cipher line of its own. libssh and the OpenSSH
# server take the global cipher line of DEFAULT, which lists CBC ciphers.
update-crypto-policies --set DEFAULT
global=$(sed -n 's/^cipher[[:space:]]*=[[:space:]]*//p' /etc/crypto-policies/state/CURRENT.pol)
printf '%s\n' "cipher@SSH = $global" 'cipher@openssh-client = -*-CBC' > /etc/crypto-policies/policies/modules/TEST-SSHCLIENT.pmod
update-crypto-policies --set DEFAULT:TEST-SSHCLIENT
