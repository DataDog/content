#!/bin/bash
# platform = multi_platform_ubuntu
# check-import = stdout

result=$XCCDF_RESULT_PASS
for motd_file in /etc/motd /run/motd /usr/lib/motd /etc/motd.d/* /run/motd.d/* /usr/lib/motd.d/* /etc/update-motd.d/*; do
    [[ -f "$motd_file" ]] || continue
    read -r mode uid gid < <(stat -Lc '%a %u %g' "$motd_file")
    if (( 8#$mode & 07133 )) || [[ "$uid" != 0 || "$gid" != 0 ]]; then
        echo "$motd_file has mode $mode and owner $uid:$gid, expected root:root and 0644 or more restrictive."
        result=$XCCDF_RESULT_FAIL
    fi
done

exit "$result"
