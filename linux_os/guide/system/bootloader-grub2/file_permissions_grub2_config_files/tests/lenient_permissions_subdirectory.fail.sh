#!/bin/bash

find {{{ grub2_boot_path }}} -type f \( -name 'grub*' -o -name user.cfg \) -exec chmod 0600 {} +
mkdir -p {{{ grub2_boot_path }}}/x86_64-efi
touch {{{ grub2_boot_path }}}/x86_64-efi/grub.efi
chmod 0644 {{{ grub2_boot_path }}}/x86_64-efi/grub.efi
