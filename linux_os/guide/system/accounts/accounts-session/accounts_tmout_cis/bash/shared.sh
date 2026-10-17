# platform = multi_platform_all

{{{ bash_instantiate_variables("var_accounts_tmout") }}}

{{% if product == "al2023" %}}
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
# An assignment of TMOUT starts a command, alone or after readonly, export,
# typeset or declare. Its value is literal when it is a number, quoted or
# not, or nothing. The shell computes the other values, such as
# "$((60 * 15))", and they stay as they are: an edit of part of one breaks
# the script. A TMOUT= inside a string, as in echo "TMOUT=0", stays too.
tmout_assignment='^(([^#]*[;&|(){])?[[:space:]]*((then|do|else)[[:space:]]+)?((readonly|export|typeset|declare)([[:space:]]+[^[:space:];&|#]+)*[[:space:]]+)?TMOUT=)'
tmout_literal="(\"[0-9]*\"|'[0-9]*'|[0-9]*)([[:space:];&|)]|\$)"

tmout_set=0
for f in "${tmout_files[@]}"; do
    [ -f "$f" ] || continue
    grep -Eq "$tmout_assignment" "$f" || continue
    tmout_set=1
    # A file whose values are all computed stays as it is.
    grep -Eq "$tmout_assignment$tmout_literal" "$f" || continue
    {{% if product == "al2023" %}}
    sed -i -E "s/^([[:space:]]*)(typeset|declare)[[:space:]]+-[[:alpha:]]+[[:space:]]+TMOUT=$tmout_literal/\\1readonly TMOUT=$var_accounts_tmout ; export TMOUT\\4/" "$f"
    {{% endif %}}
    # A rewritten value carries a mark until its line is done, so that the
    # loop goes on to the other assignments of the line.
    sed -i -E -e ':a' -e "s/$tmout_assignment$tmout_literal/\\1\\x01$var_accounts_tmout\\9/" -e 'ta' -e 's/\x01//g' "$f"
    # End the file with a newline, so that a line appended below starts a
    # line of its own.
    [ -z "$(tail -c 1 "$f")" ] || echo >> "$f"
    grep -Pq "$tmout_readonly" "$f" || echo "readonly TMOUT" >> "$f"
    grep -Pq "$tmout_export" "$f" || echo "export TMOUT" >> "$f"
done

if [ "$tmout_set" -eq 0 ]; then
    [ -z "$(tail -c 1 /etc/profile.d/tmout.sh 2>/dev/null)" ] || echo >> /etc/profile.d/tmout.sh
    printf '%s\n' "# Set the interactive shell timeout to $var_accounts_tmout seconds" \
        "readonly TMOUT=$var_accounts_tmout ; export TMOUT" >> /etc/profile.d/tmout.sh
    chmod 0644 /etc/profile.d/tmout.sh
fi
