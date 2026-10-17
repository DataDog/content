#!/bin/bash

useradd testuser_123
mkdir -p /boot/efi/EFI/cac_test
touch /boot/efi/EFI/cac_test/grub.cfg
chown testuser_123 /boot/efi/EFI/cac_test/grub.cfg
