#!/bin/bash
# packages = at

getent group group_test >/dev/null || groupadd group_test
touch /etc/at.deny
chgrp group_test /etc/at.deny
