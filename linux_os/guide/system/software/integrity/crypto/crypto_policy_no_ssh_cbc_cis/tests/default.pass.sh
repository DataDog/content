#!/bin/bash
# platform = Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,AlmaLinux OS 9
# packages = crypto-policies-scripts

# DEFAULT has SSH cipher lines without CBC ciphers.
update-crypto-policies --set DEFAULT
