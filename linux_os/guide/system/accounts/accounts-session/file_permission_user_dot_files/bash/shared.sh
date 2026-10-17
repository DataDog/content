# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

while IFS=: read -r _ _ uid _ _ home shell; do
    [ "$uid" -ge {{{ uid_min }}} ] || continue
    case "$shell" in */nologin | */false) continue ;; esac
    [ -d "$home" ] || continue
    find "$home" -maxdepth 1 -type f -name '.*' ! -name .bash_history ! -name .netrc \
        -perm /7133 -exec chmod u-xs,g-wxs,o-wxt {} +
done < /etc/passwd
