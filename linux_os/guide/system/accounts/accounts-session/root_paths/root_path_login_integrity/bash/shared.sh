# platform = multi_platform_all
# reboot = false
# strategy = configure
# complexity = low
# disruption = low

# Read the PATH of a root login shell as the check does, then create its
# missing directories and make the others owned by root and writable by
# their owner only, as the CIS remediation does. Empty, relative and
# trailing entries stay for the administrator to remove from the startup
# file that adds them.
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
{{%- if product == "ubuntu2004" %}}

# CIS Ubuntu 20.04 5.4.2.5 reads the PATH that sudo -Hiu root gives the
# login shell: the secure_path of the sudoers files that sudo reads, when
# one sets it.
for f in /etc/sudoers /etc/sudoers.d/*; do
    case $f in
    /etc/sudoers.d/*.* | *~) continue ;;
    esac
    [ -f "$f" ] || continue
    secure_path=$(sed -nE 's/^[[:space:]]*Defaults[[:space:]]+([^#]*,[[:space:]]*)?secure_path[[:space:]]*=[[:space:]]*"?([^",[:space:]]+).*/\2/p' "$f" | tail -n 1)
    [ -n "$secure_path" ] && start=$secure_path
done
{{%- endif %}}

# shellcheck disable=SC2016 # the login shell expands $PATH
root_path=$(cd "$home" 2>/dev/null || cd /
    timeout 30 env -i HOME="$home" SHELL="$shell" USER=root LOGNAME=root PATH="$start" \
        "$shell" -l -c 'printf "\nROOT_LOGIN_PATH=%s\n" "$PATH"' </dev/null 2>/dev/null |
        sed -n 's/^ROOT_LOGIN_PATH=//p' | tail -n 1)

IFS=: read -ra entries <<<"$root_path"
for entry in "${entries[@]}"; do
    case $entry in
    /*) ;;
    *) continue ;;
    esac
    [ -e "$entry" ] || mkdir -p "$entry"
    [ -d "$entry" ] || continue
    [ "$(stat -Lc %u "$entry")" -eq 0 ] || chown root "$entry"
    [ $((0$(stat -Lc %a "$entry") & 022)) -eq 0 ] || chmod go-w "$entry"
done
