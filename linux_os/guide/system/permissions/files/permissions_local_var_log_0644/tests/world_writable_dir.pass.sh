#!/bin/bash

find /var/log -type f -exec chmod u-x,g-wx,o-wx {} \;
mkdir -p /var/log/testme
chmod 0777 /var/log/testme
