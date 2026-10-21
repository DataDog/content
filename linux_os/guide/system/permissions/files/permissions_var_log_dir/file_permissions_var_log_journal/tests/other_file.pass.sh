#!/bin/bash

find /var/log -type f -name '*.journal*' -exec chmod u-x,g-wx,o-rwx {} \;
mkdir -p /var/log/journal/test
touch /var/log/journal/test/journal.conf
chmod 0644 /var/log/journal/test/journal.conf
