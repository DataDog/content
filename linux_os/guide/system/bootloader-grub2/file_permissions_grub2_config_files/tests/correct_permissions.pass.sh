#!/bin/bash

mkdir -p {{{ grub2_boot_path }}}
touch {{{ grub2_boot_path }}}/grubenv
find {{{ grub2_boot_path }}} -type f \( -name 'grub*' -o -name user.cfg \) -exec chmod 0600 {} +
