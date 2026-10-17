#!/bin/bash
# platform = AlmaLinux OS 9,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10
# packages = grub2,grubby

# Any value counts, as in the CIS audit, which looks for the argument name.
sed -i 's/\s*systemd\.confirm_spawn\S*//g' /etc/default/grub

mkdir -p /boot/loader/entries
rm -f /boot/loader/entries/*.conf
{
    echo 'title OS 1'
    echo 'version 5.0'
    echo 'linux /vmlinuz'
    echo 'initrd /initramfs'
    echo 'options root=UUID=abc-def rhgb ro quiet systemd.confirm_spawn=0'
} > /boot/loader/entries/mock.conf
