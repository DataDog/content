#!/bin/bash
# platform = Red Hat Enterprise Linux 7,Ubuntu 20.04
# packages = at

touch /etc/at.deny
chgrp daemon /etc/at.deny
