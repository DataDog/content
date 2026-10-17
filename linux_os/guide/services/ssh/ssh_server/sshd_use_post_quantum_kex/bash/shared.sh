# platform = multi_platform_all
# reboot = false
# strategy = configure
# complexity = low
# disruption = low

# OpenSSH 9.9 added sntrup761x25519-sha512 as a second name of the algorithm.
pq_kex="sntrup761x25519-sha512@openssh.com sntrup761x25519-sha512"
supported_kex=$(ssh -Q kex 2>/dev/null)

for f in {{{ sshd_main_config_file }}} {{{ sshd_config_dir }}}/*.conf; do
    [ -f "$f" ] || continue
    out=""
    changed=""
    while IFS= read -r line || [ -n "$line" ]; do
        # The list is the first argument. A comment may follow it.
        lower=${line,,}
        if [[ $lower =~ ^([[:space:]]*kexalgorithms[[:space:]]+)([^[:space:]]+) ]]; then
            head=${line:0:${#BASH_REMATCH[1]}}
            value=${line:${#BASH_REMATCH[1]}:${#BASH_REMATCH[2]}}
            tail=${line:${#BASH_REMATCH[0]}}
            case $value in
            -*)
                # A list that removes algorithms: drop the patterns that match
                # the algorithm, and name the other algorithms that a dropped
                # wildcard pattern matched, so that they stay removed.
                kept=""
                IFS=, read -r -a patterns <<< "${value#-}"
                for p in "${patterns[@]}"; do
                    hit=""
                    for n in $pq_kex; do
                        # OpenSSH patterns take * and ? as bash patterns do.
                        # shellcheck disable=SC2053
                        if [[ $p != '!'* && $n == $p ]]; then
                            hit=1
                        fi
                    done
                    if [ -z "$hit" ]; then
                        kept="$kept,$p"
                    elif [[ $p == *[*?]* ]]; then
                        for a in $supported_kex; do
                            # shellcheck disable=SC2053
                            if [[ $a == $p && " $pq_kex " != *" $a "* && "$kept," != *",$a,"* ]]; then
                                kept="$kept,$a"
                            fi
                        done
                    fi
                done
                kept=${kept#,}
                if [ "-$kept" != "$value" ]; then
                    changed=1
                    # Drop the directive once its list is empty.
                    if [ -z "$kept" ]; then
                        continue
                    fi
                    line="$head-$kept$tail"
                fi
                ;;
            [+^]*)
                ;;
            *)
                # A list that replaces the default: name the algorithm first.
                if [[ ",$value," != *,sntrup761x25519-sha512@openssh.com,* && ",$value," != *,sntrup761x25519-sha512,* ]]; then
                    changed=1
                    line="${head}sntrup761x25519-sha512@openssh.com,$value$tail"
                fi
                ;;
            esac
        fi
        out="$out$line"$'\n'
    done < "$f"
    if [ -n "$changed" ]; then
        printf '%s' "$out" > "$f"
    fi
done
