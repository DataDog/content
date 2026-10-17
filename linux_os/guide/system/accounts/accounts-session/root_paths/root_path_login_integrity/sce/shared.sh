#!/bin/bash
# platform = multi_platform_all
# check-import = stdout

# Check the PATH of a root login shell, which the CIS audit reads with
# su - root or sudo -Hiu root: each entry must be the absolute path of an
# existing directory owned by root and writable by its owner only. An empty
# entry, a trailing one included, stands for the current directory.
#
# su and sudo need the capability to set the groups of root, which the
# scanner may lack, so start the login shell of root directly, with the
# environment su - root gives it: the PATH set by pam_env from
# /etc/environment, else ENV_SUPATH or ENV_ROOTPATH of /etc/login.defs,
# else the default of su. The shell then reads /etc/profile and the startup
# files of root, which complete the PATH.

home=$(awk -F: '$1 == "root" { print $6; exit }' /etc/passwd)
shell=$(awk -F: '$1 == "root" { print $7; exit }' /etc/passwd)
home=${home:-/root}
shell=${shell:-/bin/sh}

start=$(sed -n 's/^[[:space:]]*PATH[[:space:]]*=[[:space:]]*//p' /etc/environment 2>/dev/null | tail -n 1 | tr -d "\"'")
if [ -z "$start" ]; then
    start=$(awk '$1 == "ENV_ROOTPATH" { r = $2 } $1 == "ENV_SUPATH" { s = $2 }
        END { p = s != "" ? s : r; sub(/^PATH=/, "", p); print p }' /etc/login.defs 2>/dev/null)
fi
start=${start:-/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin}

# shellcheck disable=SC2016 # the login shell expands $PATH
root_path=$(cd "$home" 2>/dev/null || cd /
    timeout 30 env -i HOME="$home" SHELL="$shell" USER=root LOGNAME=root PATH="$start" \
        "$shell" -l -c 'printf "\nROOT_LOGIN_PATH=%s\n" "$PATH"' </dev/null 2>/dev/null |
        sed -n 's/^ROOT_LOGIN_PATH=//p' | tail -n 1)
if [ -z "$root_path" ]; then
    echo "cannot read the PATH of a root login shell"
    exit "$XCCDF_RESULT_FAIL"
fi

result=$XCCDF_RESULT_PASS
unsafe() {
    echo "root's PATH $root_path: $*"
    result=$XCCDF_RESULT_FAIL
}

case $root_path in
*:) unsafe "trailing empty entry" ;;
esac
# bash 4.4 writes a here-string to a file in /tmp, which is read-only in
# a scanned root.
set -f
IFS=:
# shellcheck disable=SC2206
entries=($root_path)
unset IFS
set +f
for entry in "${entries[@]}"; do
    case $entry in
    /*) ;;
    "")
        unsafe "empty entry"
        continue
        ;;
    *)
        unsafe "relative entry \"$entry\""
        continue
        ;;
    esac
    if [ ! -d "$entry" ]; then
        unsafe "\"$entry\" is not an existing directory"
        continue
    fi
    owner=$(stat -Lc %u "$entry")
    mode=$(stat -Lc %a "$entry")
    [ "$owner" -eq 0 ] || unsafe "\"$entry\" is owned by UID $owner"
    [ $((0$mode & 022)) -eq 0 ] || unsafe "\"$entry\" has mode $mode"
done
exit "$result"
