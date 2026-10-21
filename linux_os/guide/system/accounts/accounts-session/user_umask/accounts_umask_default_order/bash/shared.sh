# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_instantiate_variables("var_accounts_user_umask") }}}

{{{ bash_umask_to_dec() }}}

# Set every less restrictive umask of these locations to the variable, as
# the CIS remediation does, then set the umask in a profile.d script unless
# one already sets it. An octal or absolute symbolic value at least as
# restrictive stays.
floor=$(( 8#$var_accounts_user_umask ))
readarray -t profile_d_scripts < <(find /etc/profile.d/ -type f -name '*.sh' 2>/dev/null)

profile_d_set=0
for f in "${profile_d_scripts[@]}" /etc/profile /etc/bashrc /etc/bash.bashrc /etc/login.defs /etc/default/login; do
    [ -f "$f" ] || continue
    profile_d=0
    case $f in
    /etc/profile.d/*) profile_d=1 ;;
    esac
    while IFS=: read -r line value; do
        # Leave a value that the shell computes, such as "$(cat file)", as
        # it is: an edit of part of it breaks the script.
        if [[ $value == *[\$\`]* ]]; then
            profile_d_set=$(( profile_d_set | profile_d ))
            continue
        fi
        # The check reads the value up to a blank, a # or a semicolon, so put
        # a blank between the value and a command separator that follows it.
        sed -i -E "${line}s/^(\s*umask\s+[^[:space:]#;&|()<>]+)([;&|()<>])/\1 \2/I" "$f"
        value=${value%%[;&|()<>]*}
        [ -n "$value" ] || continue
        profile_d_set=$(( profile_d_set | profile_d ))
        dec=$(umask_to_dec "$value")
        if [ "$dec" != INVALID ] && (( (dec & floor) == floor )); then
            continue
        fi
        sed -i -E "${line}s/^(\s*umask\s+)[^[:space:]#;&|()<>]+/\1${var_accounts_user_umask}/I" "$f"
    done < <(grep -nPio '^\h*umask\h+\K[^\s#]+' "$f")
done

if [ -f /etc/pam.d/postlogin ]; then
    while IFS=: read -r line value; do
        dec=$(umask_to_dec "$value")
        if [ "$dec" != INVALID ] && (( (dec & floor) == floor )); then
            continue
        fi
        sed -i -E "${line}s/(\bpam_umask\.so\s+(\S+\s+)*umask=)[^[:space:]#]+/\1${var_accounts_user_umask}/" /etc/pam.d/postlogin
    done < <(grep -nPo '^\h*session\h+[^#\n\r]+\h+pam_umask\.so\h+([^#\n\r]+\h+)?umask=\K[^\s#]+' /etc/pam.d/postlogin)
fi

if [ "$profile_d_set" -eq 0 ]; then
    echo "umask $var_accounts_user_umask" >> /etc/profile.d/50-systemwide_umask.sh
    chmod 0644 /etc/profile.d/50-systemwide_umask.sh
fi
