#!/bin/bash
# platform = Ubuntu 24.04,Ubuntu 26.04
# check-import = stdout

# Follow the CIS audit: every readable file that a pam_motd entry of sshd,
# login, su or gdm-password names with motd= must hold no \v, \r, \m or \s
# escape and no word naming the operating system.
result=$XCCDF_RESULT_PASS
os_id=$(awk -F= '$1 == "ID" { gsub(/^"|"$/, "", $2); print $2; exit }' /etc/os-release 2>/dev/null)
unsafe='(\\[vrms])'
[[ -n "$os_id" ]] && unsafe="(\\\\[vrms]|\\b${os_id}\\b)"

for service in sshd login su gdm-password; do
    if [[ -f "/etc/pam.d/$service" ]]; then
        pam_file="/etc/pam.d/$service"
    elif [[ -f "/usr/lib/pam.d/$service" ]]; then
        pam_file="/usr/lib/pam.d/$service"
    else
        continue
    fi

    while IFS= read -r line; do
        while IFS= read -r motd_path; do
            motd_path=${motd_path#\"}; motd_path=${motd_path%\"}
            motd_path=${motd_path#\'}; motd_path=${motd_path%\'}
            [[ -r "$motd_path" ]] || continue
            if grep -Piq -- "$unsafe" "$motd_path"; then
                echo "$motd_path, named in $pam_file, contains operating-system information or a prohibited escape sequence."
                result=$XCCDF_RESULT_FAIL
            fi
        done < <(grep -oP '\bmotd=\K"[^"]+"|\bmotd=\K'"'"'[^'"'"']+'"'"'|\bmotd=\K\S+' <<< "$line")
    done < <(grep -Pi '^\h*session\h+(required|optional)\h+pam_motd\.so\b.*\bmotd=' "$pam_file" 2>/dev/null)
done

exit "$result"
