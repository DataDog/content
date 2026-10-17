# platform = Red Hat Enterprise Linux 10
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

# The RHEL 10 benchmark leaves the MACs of sshd to the system-wide crypto
# policy, whose DEFAULT policy offers the SHA-1 and UMAC-128 MACs that
# 5.1.15 prohibits. When sshd offers one of them, drop the MACs lines
# that override the policy and add the NO-SSHWEAKMACS subpolicy of the
# benchmark, last, so that it overrides earlier subpolicies.
weak='{{{ sshd_cis_weak_macs() }}}'
offered=$(/usr/sbin/sshd -T 2>/dev/null | awk '$1 == "macs" { print tolower($2); exit }')
found=
IFS=, read -r -a list <<< "$weak"
for alg in "${list[@]}"; do
    case ",$offered," in
    *",$alg,"*) found=1 ;;
    esac
done
if [ -n "$found" ]; then
    for f in /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf; do
        [ -f "$f" ] && sed -i '/^[[:space:]]*MACs[[:space:]]/Id' "$f"
    done
    module=/etc/crypto-policies/policies/modules/NO-SSHWEAKMACS.pmod
    module_line='mac@SSH = -HMAC-MD5* -UMAC-64* -UMAC-128* -HMAC-SHA1*'
    grep -qsxF -- "$module_line" "$module" || echo "$module_line" >>"$module"
    chmod 0644 "$module"
    crypto_policy=$(update-crypto-policies --show | sed -e 's/$/:/' -e 's/:NO-SSHWEAKMACS:/:/g' -e 's/:$//')
    update-crypto-policies --set "$crypto_policy:NO-SSHWEAKMACS"
fi
