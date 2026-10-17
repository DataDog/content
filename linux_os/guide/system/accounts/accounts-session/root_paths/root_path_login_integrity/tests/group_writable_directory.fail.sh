#!/bin/bash

mkdir -p /opt/cac_bin
chmod 0775 /opt/cac_bin
printf 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/cac_bin\nexport PATH\n' >/root/.bash_profile
