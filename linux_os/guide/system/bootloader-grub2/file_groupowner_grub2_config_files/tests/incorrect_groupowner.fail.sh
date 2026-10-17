#!/bin/bash

groupadd group_test
mkdir -p {{{ grub2_boot_path }}}
touch {{{ grub2_boot_path }}}/grubenv
chgrp group_test {{{ grub2_boot_path }}}/grubenv
