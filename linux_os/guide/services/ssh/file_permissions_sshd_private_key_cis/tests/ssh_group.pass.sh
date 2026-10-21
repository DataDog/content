#!/bin/bash
# platform = Ubuntu 20.04

# openssh-client creates the ssh group, whose keys may have mode 0640.
chmod 0600 /etc/ssh/*_key
FAKE_KEY=$(mktemp -p /etc/ssh/ XXXX_key)
chown root:ssh "$FAKE_KEY"
chmod 0640 "$FAKE_KEY"
