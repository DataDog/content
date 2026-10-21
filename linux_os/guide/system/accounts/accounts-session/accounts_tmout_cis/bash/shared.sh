# platform = multi_platform_all

{{{ bash_instantiate_variables("var_accounts_tmout") }}}

{{% if product in ["al2023", "rhel7"] %}}
tmout_files=(/etc/bashrc /etc/profile /etc/profile.d/*.sh)
tmout_readonly='^\s*([^#]+;\s*)?readonly\s+TMOUT(\s+|\s*;|\s*$|=[1-9]\d*)\b'
tmout_export='^\s*([^#]+;\s*)?export\s+TMOUT(\s+|\s*;|\s*$|=[1-9]\d*)\b'
{{% else %}}
{{% if product in ["rhel9", "almalinux9"] %}}
tmout_files=(/etc/*bashrc /etc/profile /etc/profile.d/*.sh /etc/profile.d/sh.local /usr/etc/profile.d/*.sh /usr/etc/profile.d/sh.local)
{{% else %}}
tmout_files=(/etc/*bashrc /etc/profile /etc/profile.d/*.sh)
{{% endif %}}
tmout_readonly='^\h*(typeset\h-xr\hTMOUT=\d+|([^#\n\r]+)?\breadonly\h+TMOUT\b)'
tmout_export='^\h*(typeset\h-xr\hTMOUT=\d+|([^#\n\r]+)?\bexport\b([^#\n\r]+\b)?TMOUT\b)'
{{% endif %}}

tmout_set=0
for f in "${tmout_files[@]}"; do
    [ -f "$f" ] || continue
    grep -Eq '^[^#]*\bTMOUT=' "$f" || continue
    tmout_set=1
    # Leave a value that the shell computes, such as "$((60 * 15))", as it
    # is: an edit of part of it breaks the script. A file with such values
    # alone stays as it is.
    grep -Eq '^[^#]*\bTMOUT=[^[:space:];#$`]*([[:space:];#]|$)' "$f" || continue
    {{% if product in ["al2023", "rhel7"] %}}
    sed -i -E 's/^(\s*)(typeset|declare)\s+-[[:alpha:]]+\s+TMOUT=[^[:space:];#$`]*([[:space:];#]|$)/\1readonly TMOUT='"$var_accounts_tmout"' ; export TMOUT\3/' "$f"
    {{% endif %}}
    sed -i -E 's/^([^#]*\bTMOUT=)[^[:space:];#$`]*([[:space:];#]|$)/\1'"$var_accounts_tmout"'\2/' "$f"
    grep -Pq "$tmout_readonly" "$f" || echo "readonly TMOUT" >> "$f"
    grep -Pq "$tmout_export" "$f" || echo "export TMOUT" >> "$f"
done

if [ "$tmout_set" -eq 0 ]; then
    printf '%s\n' "# Set the interactive shell timeout to $var_accounts_tmout seconds" \
        "readonly TMOUT=$var_accounts_tmout ; export TMOUT" >> /etc/profile.d/tmout.sh
    chmod 0644 /etc/profile.d/tmout.sh
fi
