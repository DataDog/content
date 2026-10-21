#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = at

touch /etc/at.allow
chgrp daemon /etc/at.allow
