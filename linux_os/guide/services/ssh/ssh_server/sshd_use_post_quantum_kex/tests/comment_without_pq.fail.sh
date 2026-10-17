#!/bin/bash
# packages = openssh-server

sed -i "/^[[:space:]]*KexAlgorithms/Id" {{{ sshd_main_config_file }}}
rm -f {{{ sshd_config_dir }}}/*kex*.conf
echo "KexAlgorithms curve25519-sha256 # sntrup761x25519-sha512@openssh.com disabled" >> {{{ sshd_main_config_file }}}
