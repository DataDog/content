# platform = Ubuntu 24.04,Ubuntu 26.04
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

# The value of motd= is a colon-separated list of files (pam_motd(8)).
while IFS= read -r motd_path; do
    motd_path=${motd_path#\"}; motd_path=${motd_path%\"}
    motd_path=${motd_path#\'}; motd_path=${motd_path%\'}
    [[ -e "$motd_path" ]] || continue
    chown root:root "$motd_path"
    chmod u-x,go-wx "$motd_path"
done < <(grep -hPo '\bmotd=\K("[^"]+"|'"'"'[^'"'"']+'"'"'|\S+)' /etc/pam.d/* 2>/dev/null | tr ':' '\n' | sort -u)
