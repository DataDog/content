#!/bin/bash
# platform = Ubuntu 24.04,Ubuntu 26.04
# check-import = stdout

# Follow the CIS audit: every existing file that a line of /etc/pam.d names
# with motd=, a commented line included, must be owned by root:root with
# mode 0644 or more restrictive. The value of motd= is a colon-separated
# list of files (pam_motd(8)).
result=$XCCDF_RESULT_PASS

while IFS= read -r motd_path; do
    motd_path=${motd_path#\"}; motd_path=${motd_path%\"}
    motd_path=${motd_path#\'}; motd_path=${motd_path%\'}
    [[ -e "$motd_path" ]] || continue

    read -r mode uid gid < <(stat -Lc '%a %u %g' "$motd_path")
    if (( 8#$mode & 0133 )) || [[ "$uid" != 0 || "$gid" != 0 ]]; then
        echo "$motd_path has mode $mode and owner $uid:$gid, where root:root and 0644 or more restrictive are expected."
        result=$XCCDF_RESULT_FAIL
    fi
done < <(grep -hPo '\bmotd=\K("[^"]+"|'"'"'[^'"'"']+'"'"'|\S+)' /etc/pam.d/* 2>/dev/null | tr ':' '\n' | sort -u)

exit "$result"
