# platform = multi_platform_all
# reboot = false
# strategy = configure
# complexity = low
# disruption = low

for f in {{{ sshd_main_config_file }}} {{{ sshd_config_dir }}}/*.conf; do
    [ -f "$f" ] || continue
    # Lists that remove algorithms from the default: take the algorithm out,
    # and drop the directive when nothing else is left.
    sed -ri '/^[[:space:]]*kexalgorithms[[:space:]]+-/I { s/sntrup761x25519-sha512(@openssh\.com)?,?//Ig; s/,[[:space:]]*$//; }' "$f"
    sed -ri '/^[[:space:]]*kexalgorithms[[:space:]]+-[[:space:]]*$/Id' "$f"
    # Lists that replace the default: name the algorithm first.
    sed -ri '/^[[:space:]]*kexalgorithms[[:space:]]+[^+^[:space:]-]/I { /sntrup761x25519-sha512/I! s/^([[:space:]]*[^[:space:]]+[[:space:]]+)/\1sntrup761x25519-sha512@openssh.com,/ }' "$f"
done
