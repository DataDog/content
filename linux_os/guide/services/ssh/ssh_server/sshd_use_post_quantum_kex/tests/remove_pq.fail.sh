#!/bin/bash
# packages = openssh-server

sed -i "/^[[:space:]]*KexAlgorithms/Id" {{{ sshd_main_config_file }}}
rm -f {{{ sshd_config_dir }}}/*kex*.conf
echo "KexAlgorithms -sntrup761x25519-sha512@openssh.com" >> {{{ sshd_main_config_file }}}
