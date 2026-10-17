#!/bin/bash
# packages = sudo

echo 'user ALL=(admin) ALL' > /etc/sudoers
# sudo skips the files of /etc/sudoers.d whose names contain a "."
echo 'ALL ALL=(ALL:ALL) ALL' > /etc/sudoers.d/foo.rpmsave
