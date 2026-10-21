#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = at

touch /etc/at.deny
chgrp daemon /etc/at.deny
