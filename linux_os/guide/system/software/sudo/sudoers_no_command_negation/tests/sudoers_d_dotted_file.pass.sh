#!/bin/bash
# platform = multi_platform_all
# packages = sudo

echo 'nobody ALL=/bin/ls, (!bob alice) /bin/dog !arg, /bin/cat' > /etc/sudoers
echo 'jen		ALL, !SERVERS = ALL' >> /etc/sudoers
echo 'jen !fred		ALL, !SERVERS = /bin/sh' >> /etc/sudoers
echo 'nobody ALL=/bin/ls, (bob !alice) /bin/dog, /bin/cat !arg' > /etc/sudoers.d/foo
# sudo skips the files of /etc/sudoers.d whose names contain a "."
echo 'user ALL = ALL ,!/bin/sh' > /etc/sudoers.d/bar.rpmnew
