#!/bin/bash
# platform = multi_platform_ubuntu
# packages = grub2

# Add the argument to GRUB_CMDLINE_LINUX_DEFAULT, which Ubuntu puts on the
# linux line of the default entries
rm -f /etc/default/grub.d/*
echo "GRUB_CMDLINE_LINUX=\"\"" > /etc/default/grub
echo "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet {{{ ARG_NAME }}}\"" >> /etc/default/grub
{{{ grub_command("update") }}}
