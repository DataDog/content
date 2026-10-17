#!/bin/bash

useradd testuser_123
mkdir -p {{{ grub2_boot_path }}}
touch {{{ grub2_boot_path }}}/grubenv
chown testuser_123 {{{ grub2_boot_path }}}/grubenv
