#!/bin/bash
# platform = Ubuntu 24.04
# The Ubuntu 24.04 STIG accepts the mode 2755 that the vendor
# /usr/lib/tmpfiles.d/systemd.conf gives the journal directories.

mkdir -p /run/log/journal /var/log/journal
find /run/log/journal /var/log/journal -type d -exec chmod 2755 {} \;
