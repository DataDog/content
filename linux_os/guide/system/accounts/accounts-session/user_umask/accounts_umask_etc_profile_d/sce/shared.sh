#!/bin/bash
# platform = multi_platform_all
# check-import = stdout
# check-export = var_accounts_user_umask=var_accounts_user_umask

# Follow the CIS audit (5.4.3.3 of RHEL 8 v4.0.0, RHEL 10 v1.0.1 and Ubuntu):
# a script matching /etc/profile.d/*.sh sets the umask, and every umask
# command in these scripts sets var_accounts_user_umask or a more restrictive
# value, in octal or as an absolute symbolic mode such as u=rwx,g=rx,o=,
# which the audit names as the same value. A relative symbolic value fails.
floor=$(( 8#$XCCDF_VALUE_var_accounts_user_umask ))

{{{ bash_umask_to_dec() }}}

result=$XCCDF_RESULT_PASS
found=
for f in /etc/profile.d/*.sh; do
    [ -r "$f" ] || continue
    while IFS= read -r line; do
        arg=$(printf '%s\n' "$line" | grep -Poi '^\h*umask\h+\K[^[:space:]#;]+')
        [ -n "$arg" ] || continue
        found=1
        dec=$(umask_to_dec "$arg")
        if [ "$dec" = INVALID ] || [ $(( dec & floor )) -ne "$floor" ]; then
            echo "$f sets a umask less restrictive than $XCCDF_VALUE_var_accounts_user_umask: $line"
            result=$XCCDF_RESULT_FAIL
        fi
    done < <(grep -Psi '^\h*umask\h+\S' "$f" 2>/dev/null)
done
if [ -z "$found" ]; then
    echo "No script matching /etc/profile.d/*.sh sets the umask."
    result=$XCCDF_RESULT_FAIL
fi

exit "$result"
