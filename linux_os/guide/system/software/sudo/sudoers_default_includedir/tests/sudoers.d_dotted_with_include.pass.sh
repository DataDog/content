#!/bin/bash
# platform = multi_platform_all

mkdir -p /etc/sudoers.d
# Ensure default config is there
if ! grep -q "#includedir /etc/sudoers.d" /etc/sudoers; then
    echo "#includedir /etc/sudoers.d" >> /etc/sudoers
fi

# sudo skips the files of /etc/sudoers.d whose names contain a "."
echo "#include /etc/my-sudoers" > /etc/sudoers.d/my-sudoers.rpmsave
