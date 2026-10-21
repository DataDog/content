#!/bin/bash
# platform = Ubuntu 20.04
# packages = sudo

# /etc/environment names a group writable directory, and sudo -Hiu root,
# which the audit runs, starts root from secure_path instead.
mkdir -p /opt/cac_bin
chmod 0775 /opt/cac_bin
sed -i 's|^PATH=.*|PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/cac_bin"|' /etc/environment
sed -i 's|^\(Defaults[[:space:]]*secure_path=\).*|\1"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"|' /etc/sudoers
printf 'export PATH\n' >/root/.bash_profile
