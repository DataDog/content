#!/bin/bash

mkdir -p /boot/efi/EFI/cac_test
touch /boot/efi/EFI/cac_test/grub.cfg /boot/efi/EFI/cac_test/grubx64.efi
find /boot/efi/EFI -type f \( -name 'grub*' -o -name user.cfg \) -exec chmod 0700 {} +
