#!/bin/bash
# variables = var_kernel_module_absent_disabled=true

kernel_mod_files=( "/etc/modprobe.d/*.conf" "/etc/modprobe.conf" "/etc/modules-load.d/*.conf" "/run/modules-load.d/*.conf" "/usr/lib/modules-load.d/*.conf" "/run/modprobe.d/*.conf" "/usr/lib/modprobe.d/*.conf" )
for filename in "${kernel_mod_files[@]}"; do
    for file in $filename; do
        if [[ -f $file ]]; then
            rm -f $file
        fi
    done
done
mkdir -p /lib/modules/0.0.0-test/kernel/test
touch /lib/modules/0.0.0-test/kernel/test/{{{ KERNMODULE }}}.ko.xz
