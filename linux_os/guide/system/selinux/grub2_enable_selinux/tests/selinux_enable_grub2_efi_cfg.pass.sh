#!/bin/bash
# packages = grub2-common
# platform = Red Hat Enterprise Linux 7

[ -e /etc/default/grub ] || echo 'GRUB_CMDLINE_LINUX="quiet"' > /etc/default/grub
if [ ! -e /etc/grub2-efi.cfg ]; then
    mkdir -p /boot/efi/EFI/redhat
    echo "linuxefi /vmlinuz-3.10.0 root=/dev/vda1 ro" > /boot/efi/EFI/redhat/grub.cfg
    ln -sfn ../boot/efi/EFI/redhat/grub.cfg /etc/grub2-efi.cfg
fi
for f in /etc/default/grub /etc/grub2.cfg /etc/grub2-efi.cfg /etc/grub.d/*; do
    if [ -e "$f" ]; then
        sed -i --follow-symlinks "s/selinux=0//gI;s/enforcing=0//gI" "$f"
    fi
done
