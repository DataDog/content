#!/bin/bash

groupadd group_test
mkdir -p /boot/efi/EFI/cac_test
touch /boot/efi/EFI/cac_test/grub.cfg
chgrp group_test /boot/efi/EFI/cac_test/grub.cfg
