#!/bin/bash
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 10
# packages = crypto-policies-scripts

# The remediation appends its line to a module whose last line has no
# newline.
printf '%s' 'mac = -UMAC-64' > /etc/crypto-policies/policies/modules/NO-WEAKMAC.pmod
update-crypto-policies --set DEFAULT
