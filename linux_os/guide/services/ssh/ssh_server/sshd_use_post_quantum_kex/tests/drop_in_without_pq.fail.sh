#!/bin/bash
# packages = openssh-server

sed -i "/^[[:space:]]*KexAlgorithms/Id" {{{ sshd_main_config_file }}}
mkdir -p {{{ sshd_config_dir }}}
echo "KexAlgorithms curve25519-sha256" > {{{ sshd_config_dir }}}/50-kex.conf
