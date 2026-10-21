#!/bin/bash
#

mkdir -p /etc/ssh/keys
for key in /etc/ssh/*.pub; do
    if [ -e "$key" ]; then
        mv "$key" /etc/ssh/keys
    fi
done
