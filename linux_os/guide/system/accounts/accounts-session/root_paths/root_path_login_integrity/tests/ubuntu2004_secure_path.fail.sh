#!/bin/bash
# platform = Ubuntu 20.04
# packages = sudo

# sudo -Hiu root, which the audit runs, starts root from secure_path.
rm -rf /nonexistent-securepath
sed -i 's|^\(Defaults[[:space:]]*secure_path=\).*|\1"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/nonexistent-securepath"|' /etc/sudoers
printf 'export PATH\n' >/root/.bash_profile
