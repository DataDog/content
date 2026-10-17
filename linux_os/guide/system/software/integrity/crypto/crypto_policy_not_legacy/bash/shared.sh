# platform = multi_platform_all
# reboot = true
# strategy = configure
# complexity = low
# disruption = low

crypto_policy=$(update-crypto-policies --show)
case "$crypto_policy" in
LEGACY | LEGACY:*)
    crypto_policy="DEFAULT${crypto_policy#LEGACY}"
    ;;
esac
if [ "$crypto_policy" != "$(cat /etc/crypto-policies/state/current 2>/dev/null)" ] ||
    [ /etc/crypto-policies/config -nt /etc/crypto-policies/state/current ] ||
    [ ! -e /etc/crypto-policies/back-ends/nss.config ]; then
    update-crypto-policies --set "$crypto_policy"
fi
