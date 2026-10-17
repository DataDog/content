#!/bin/bash
# packages = openssh-server

sed -i "/^[[:space:]]*KexAlgorithms/Id" {{{ sshd_main_config_file }}}
rm -f {{{ sshd_config_dir }}}/*kex*.conf
echo "KexAlgorithms +diffie-hellman-group14-sha256" >> {{{ sshd_main_config_file }}}
