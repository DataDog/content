#!/bin/bash
# platform = Red Hat Enterprise Linux 8
# packages = crypto-policies-scripts

# DEFAULT has no SSH cipher lines, and its global cipher line lists CBC ciphers.
update-crypto-policies --set DEFAULT
