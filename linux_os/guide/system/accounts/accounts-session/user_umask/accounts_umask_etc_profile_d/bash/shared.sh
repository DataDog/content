# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_instantiate_variables("var_accounts_user_umask") }}}

umask_set=0
for f in /etc/profile.d/*.sh; do
    [ -f "$f" ] || continue
    while IFS=: read -r line value; do
        umask_set=1
        if [[ "$value" =~ ^[0-7]{3,4}$ ]] &&
            (( (8#$value & 8#$var_accounts_user_umask) == 8#$var_accounts_user_umask )); then
            continue
        fi
        sed -i -E "${line}s/^(\s*umask\s+)[^[:space:]#;]+/\1${var_accounts_user_umask}/I" "$f"
    done < <(grep -nPio '^\h*umask\h+\K[^\s#;]+' "$f")
done

if [ "$umask_set" -eq 0 ]; then
    echo "umask $var_accounts_user_umask" >> /etc/profile.d/60-default_umask.sh
    chmod 0644 /etc/profile.d/60-default_umask.sh
fi
