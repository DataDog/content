#!/bin/bash
# platform = Ubuntu 20.04

mkdir -p /boot/grub
cat > /boot/grub/grub.cfg <<'GRUBCFG'
menuentry 'Ubuntu' --class ubuntu {
	linux	/boot/vmlinuz-5.15.0-1084-aws root=PARTUUID=1 ro console=tty1 apparmor=1 security=apparmor
	initrd	/boot/initrd.img-5.15.0-1084-aws
}
menuentry 'Ubuntu, with Linux 5.15.0-1084-aws (recovery mode)' {
	linux	/boot/vmlinuz-5.15.0-1084-aws root=PARTUUID=1 ro recovery nomodeset
	initrd	/boot/initrd.img-5.15.0-1084-aws
}
GRUBCFG
