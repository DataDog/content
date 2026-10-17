# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_instantiate_variables("var_accounts_user_umask") }}}

readarray -t profile_d_scripts < <(find /etc/profile.d/ -type f -name '*.sh' 2>/dev/null)

for f in /etc/profile /etc/bashrc /etc/bash.bashrc /etc/profile.d/sh.local "${profile_d_scripts[@]}"; do
    [ -f "$f" ] || continue
    while IFS=: read -r line value; do
        # The check reads the value up to a blank or a #, so put a blank
        # between the value and a command separator that follows it.
        sed -i -E "${line}s/^(\s*umask\s+[^[:space:]#;&|()<>]+)([;&|()<>])/\1 \2/I" "$f"
        value=${value%%[;&|()<>]*}
        if [[ "$value" =~ ^[0-7]{3,4}$ ]] &&
            (( (8#$value & 8#$var_accounts_user_umask) == 8#$var_accounts_user_umask )); then
            continue
        fi
        sed -i -E "${line}s/^(\s*umask\s+)[^[:space:]#;&|()<>]+/\1${var_accounts_user_umask}/I" "$f"
    done < <(grep -nPio '^\h*umask\h+\K[^\s#]+' "$f")
done
