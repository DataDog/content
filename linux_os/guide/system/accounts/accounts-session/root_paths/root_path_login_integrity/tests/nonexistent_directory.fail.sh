#!/bin/bash

rm -rf /root/bin
printf 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin\nexport PATH\n' >/root/.bash_profile
