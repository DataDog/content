#!/bin/bash

mkdir -p /var/log/journal/test
touch /var/log/journal/test/system.journal
chmod 0777 /var/log/journal/test/system.journal
