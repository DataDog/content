# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_instantiate_variables("var_accounts_user_umask") }}}

{{{ bash_umask_to_dec() }}}

floor=$(( 8#$var_accounts_user_umask ))
umask_set=0
for f in /etc/profile.d/*.sh; do
    [ -f "$f" ] || continue
    while IFS=: read -r line value; do
        # Leave a value that the shell computes, such as "$(cat file)", as
        # it is: an edit of part of it breaks the script.
        if [[ $value == *[\$\`]* ]]; then
            umask_set=1
            continue
        fi
        # The check reads the value up to a blank, a # or a semicolon, so put
        # a blank between the value and a command separator that follows it.
        sed -i -E "${line}s/^(\s*umask\s+[^[:space:]#;&|()<>]+)([;&|()<>])/\1 \2/I" "$f"
        value=${value%%[;&|()<>]*}
        [ -n "$value" ] || continue
        umask_set=1
        dec=$(umask_to_dec "$value")
        if [ "$dec" != INVALID ] && [ $(( dec & floor )) -eq "$floor" ]; then
            continue
        fi
        sed -i -E "${line}s/^(\s*umask\s+)[^[:space:]#;&|()<>]+/\1${var_accounts_user_umask}/I" "$f"
    done < <(grep -nPio '^\h*umask\h+\K[^\s#]+' "$f")
done

if [ "$umask_set" -eq 0 ]; then
    # End the file with a newline, so that the umask line starts a line of
    # its own.
    [ -z "$(tail -c 1 /etc/profile.d/60-default_umask.sh 2>/dev/null)" ] || echo >> /etc/profile.d/60-default_umask.sh
    echo "umask $var_accounts_user_umask" >> /etc/profile.d/60-default_umask.sh
    chmod 0644 /etc/profile.d/60-default_umask.sh
fi
