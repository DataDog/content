#!/bin/bash

find /var/log -type f -exec chmod u-x,g-wx,o-wx {} \;
for f in btmp btmp.1 btmp-20261021 wtmp wtmp.1 wtmp-20261021 lastlog lastlog.1 README; do
	touch "/var/log/$f"
	chmod 0777 "/var/log/$f"
done
