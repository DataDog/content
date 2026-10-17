#!/bin/bash

useradd cac_user
mkdir -p /opt/cac_bin
chown cac_user /opt/cac_bin
chmod 0755 /opt/cac_bin
printf 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/cac_bin\nexport PATH\n' >/root/.bash_profile
