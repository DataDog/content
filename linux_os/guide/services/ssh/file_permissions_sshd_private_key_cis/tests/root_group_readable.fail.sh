#!/bin/bash

chmod 0600 /etc/ssh/*_key
FAKE_KEY=$(mktemp -p /etc/ssh/ XXXX_key)
chown root:root "$FAKE_KEY"
chmod 0640 "$FAKE_KEY"
