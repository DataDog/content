# platform = multi_platform_all
# reboot = false
# strategy = configure
# complexity = low
# disruption = low

{{% set dedicated_ssh_groupname = groups.get("dedicated_ssh_keyowner", {}).get("name") %}}
{{%- if product == "ubuntu2004" %}}
{{%- set dedicated_ssh_groupname = "ssh" %}}
{{%- endif %}}

for keyfile in /etc/ssh/*_key; do
    test -f "$keyfile" || continue
    case "$(stat -c "%U:%G" "$keyfile")" in
    root:root)
        chmod u-xs,g-xwrs,o-xwrt "$keyfile"
        ;;
{{%- if dedicated_ssh_groupname %}}
    root:{{{ dedicated_ssh_groupname }}})
        chmod u-xs,g-xws,o-xwrt "$keyfile"
        ;;
{{%- endif %}}
    *)
        echo "Key-like file '$keyfile' is owned by an unexpected user:group combination"
        ;;
    esac
done
