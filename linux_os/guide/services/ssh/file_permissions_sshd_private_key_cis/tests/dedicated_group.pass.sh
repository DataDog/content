#!/bin/bash
# platform = multi_platform_ol,multi_platform_rhel,multi_platform_almalinux,multi_platform_fedora,Amazon Linux 2023

{{% set dedicated_ssh_groupname = groups.get("dedicated_ssh_keyowner", {"name": "root"}).get("name") %}}

if ! grep -q "^{{{ dedicated_ssh_groupname }}}:" /etc/group; then
    groupadd "{{{ dedicated_ssh_groupname }}}"
fi

chmod 0600 /etc/ssh/*_key

FAKE_KEY=$(mktemp -p /etc/ssh/ XXXX_key)
chown root:{{{ dedicated_ssh_groupname }}} "$FAKE_KEY"
chmod 0640 "$FAKE_KEY"
