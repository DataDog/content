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

# umask_to_dec prints the bits that a umask argument denies, as a decimal
# number, or INVALID for a value the audit cannot evaluate.
umask_to_dec() {
    local arg=$1 u=0 g=0 o=0 clause who perms bits deny
    if [[ $arg =~ ^[0-7]{3,4}$ ]]; then
        printf '%d' "$(( 8#$arg ))"
        return
    fi
    local IFS=,
    local -a clauses
    set -f
    # shellcheck disable=SC2206 # split the clauses at the commas
    clauses=($arg)
    set +f
    for clause in "${clauses[@]}"; do
        if [[ $clause =~ ^([augo]+)=([rwx]*)$ ]]; then
            who=${BASH_REMATCH[1]} perms=${BASH_REMATCH[2]} bits=0
            [[ $perms == *r* ]] && bits=$(( bits | 4 ))
            [[ $perms == *w* ]] && bits=$(( bits | 2 ))
            [[ $perms == *x* ]] && bits=$(( bits | 1 ))
            deny=$(( 7 - bits ))
            [[ $who == *a* ]] && { u=$deny; g=$deny; o=$deny; }
            [[ $who == *u* ]] && u=$deny
            [[ $who == *g* ]] && g=$deny
            [[ $who == *o* ]] && o=$deny
        else
            printf 'INVALID'
            return
        fi
    done
    printf '%d' "$(( u * 64 + g * 8 + o ))"
}

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
