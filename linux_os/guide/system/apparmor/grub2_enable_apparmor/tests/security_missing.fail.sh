#!/bin/bash
# platform = Ubuntu 20.04

mkdir -p /boot/grub
cat > /boot/grub/grub.cfg <<'GRUBCFG'
menuentry 'Ubuntu' --class ubuntu {
	linux	/boot/vmlinuz-5.15.0-1084-aws root=PARTUUID=1 ro console=tty1 apparmor=1
	initrd	/boot/initrd.img-5.15.0-1084-aws
}
GRUBCFG
