#!/bin/bash
# platform = Ubuntu 20.04

chmod 0600 /etc/ssh/*_key
FAKE_KEY=$(mktemp -p /etc/ssh/ XXXX_key)
chown root:ssh "$FAKE_KEY"
chmod 0660 "$FAKE_KEY"
