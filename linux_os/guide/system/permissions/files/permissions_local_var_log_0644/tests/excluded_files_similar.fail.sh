#!/bin/bash

find /var/log -type f -exec chmod u-x,g-wx,o-wx {} \;
for f in 1btmp wtmpx lastlog-1 README1; do
	touch "/var/log/$f"
	chmod 0664 "/var/log/$f"
done
