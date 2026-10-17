#!/bin/bash
# platform = multi_platform_all
# check-import = stdout
# check-export = var_accounts_user_umask=var_accounts_user_umask

# Follow the CIS audit (RHEL 9 v3.0.0 5.4.3.4): no umask command in
# /etc/profile, /etc/bashrc, /etc/bash.bashrc, /etc/profile.d/sh.local or a
# .sh file under /etc/profile.d may set a umask less restrictive than
# var_accounts_user_umask. Octal values and absolute symbolic ones such as
# u=rwx,g=rx,o= count. A relative symbolic value fails, as the audit cannot
# evaluate it.
floor=$(( 8#$XCCDF_VALUE_var_accounts_user_umask ))

{{{ bash_umask_to_dec() }}}

result=$XCCDF_RESULT_PASS
files=(/etc/profile /etc/bashrc /etc/bash.bashrc /etc/profile.d/sh.local)
while IFS= read -r -d '' f; do
    files+=("$f")
done < <(find /etc/profile.d/ -type f -name '*.sh' -print0 2>/dev/null)

for f in "${files[@]}"; do
    [ -r "$f" ] || continue
    while IFS= read -r line; do
        arg=$(printf '%s\n' "$line" | grep -Poi '^\h*umask\h+\K[^[:space:]#]+')
        [ -n "$arg" ] || continue
        dec=$(umask_to_dec "$arg")
        if [ "$dec" = INVALID ] || [ $(( dec & floor )) -ne "$floor" ]; then
            echo "$f sets a umask less restrictive than $XCCDF_VALUE_var_accounts_user_umask: $line"
            result=$XCCDF_RESULT_FAIL
        fi
    done < <(grep -Psi '^\h*umask\h+\S' "$f" 2>/dev/null)
done

exit "$result"
