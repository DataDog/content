#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# ssh-keygen -A creates root:root host keys.
FAKE_KEY=$(mktemp -p /etc/ssh/ XXXX_key)
chgrp root "$FAKE_KEY"
