#!/bin/bash
# packages = at

getent group group_test >/dev/null || groupadd group_test
touch /etc/at.allow
chgrp group_test /etc/at.allow
