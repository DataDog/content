#!/bin/bash

find /var/log -type f -exec chmod u-x,g-wx,o-wx {} \;
mkdir -p /var/log/testme
touch /var/log/testme/test.log
chmod 0644 /var/log/testme/test.log
