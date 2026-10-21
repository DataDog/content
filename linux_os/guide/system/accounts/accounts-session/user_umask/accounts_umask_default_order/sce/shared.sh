#!/bin/bash
# platform = multi_platform_all
# check-import = stdout
# check-export = var_accounts_user_umask=var_accounts_user_umask

# Follow the CIS audit of the default user umask that respects the order in
# which the umask is set (Ubuntu 20.04 v3.0.0 5.4.3.3): read the scripts
# matching /etc/profile.d/*.sh, then /etc/profile, /etc/bashrc,
# /etc/bash.bashrc, the pam_umask line of /etc/pam.d/postlogin,
# /etc/login.defs and /etc/default/login, and stop after the profile.d
# scripts or the first file that sets var_accounts_user_umask or a more
# restrictive value. A file read until then must set no less restrictive
# value, and some file has to set the umask. Octal values and absolute
# symbolic ones such as u=rwx,g=rx,o= count. A relative symbolic value
# fails, as its result depends on the umask before it.
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

# check reads the umask values that the extended regular expression $2
# extracts from file $1. It reports each less restrictive value and sets
# found when the file sets only restrictive ones.
check() {
    local file=$1 regex=$2 arg dec set='' loose=''
    [ -r "$file" ] || return
    while IFS= read -r arg; do
        set=1
        dec=$(umask_to_dec "$arg")
        if [ "$dec" = INVALID ] || [ $(( dec & floor )) -ne "$floor" ]; then
            echo "$file sets a umask less restrictive than $XCCDF_VALUE_var_accounts_user_umask: $arg"
            loose=1
        fi
    done < <(grep -Poi "$regex" "$file" 2>/dev/null)
    if [ -n "$loose" ]; then
        result=$XCCDF_RESULT_FAIL
    elif [ -n "$set" ]; then
        echo "$file sets the umask to $XCCDF_VALUE_var_accounts_user_umask or a more restrictive value"
        found=1
    fi
}

umask_regex='^\h*umask\h+\K[^\s#;]+'
while IFS= read -r -d '' f; do
    check "$f" "$umask_regex"
done < <(find /etc/profile.d/ -type f -name '*.sh' -print0 2>/dev/null)
for f in /etc/profile /etc/bashrc /etc/bash.bashrc; do
    [ -n "$found" ] || check "$f" "$umask_regex"
done
[ -n "$found" ] || check /etc/pam.d/postlogin '^\h*session\h+[^#\n\r]+\h+pam_umask\.so\h+([^#\n\r]+\h+)?umask=\K[^\s#]+'
for f in /etc/login.defs /etc/default/login; do
    [ -n "$found" ] || check "$f" "$umask_regex"
done

if [ -z "$found" ] && [ "$result" = "$XCCDF_RESULT_PASS" ]; then
    echo "No location sets the umask."
    result=$XCCDF_RESULT_FAIL
fi
exit "$result"
