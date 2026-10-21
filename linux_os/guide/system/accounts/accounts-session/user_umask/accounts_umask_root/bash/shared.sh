# platform = multi_platform_all

{{%- if product == "ubuntu2004" %}}

{{{ bash_umask_to_dec() }}}

# An octal or absolute symbolic umask at least as restrictive as 027 stays.
floor=$(( 8#027 ))
for file in /root/.bash_profile /root/.bashrc /etc/login.defs; do
    [ -f "$file" ] || continue
    while IFS=: read -r line value; do
        # Leave a value that the shell computes, such as "$(cat file)", as
        # it is: an edit of part of it breaks the script.
        if [[ $value == *[\$\`]* ]]; then
            continue
        fi
        # Put a blank between the value and a command separator that follows
        # it, so that the edit replaces the value alone.
        sed -i -E "${line}s/^(\s*umask\s+[^[:space:]#;&|()<>]+)([;&|()<>])/\1 \2/I" "$file"
        value=${value%%[;&|()<>]*}
        [ -n "$value" ] || continue
        dec=$(umask_to_dec "$value")
        if [ "$dec" != INVALID ] && (( (dec & floor) == floor )); then
            continue
        fi
        sed -i -E "${line}s/^(\s*umask\s+)[^[:space:]#;&|()<>]+/\10027/I" "$file"
    done < <(grep -nPio '^\h*umask\h+\K[^\s#]+' "$file")
done
{{%- else %}}

{{% if product == "rhel7" -%}}
for file in /root/.bash_profile /root/.bashrc; do
{{%- else -%}}
for file in /root/.bashrc /root/.profile; do
{{%- endif %}}
    if [ -f "$file" ]; then
        sed -i -E -e "s/^([^#]*\bumask)[[:space:]]+[[:digit:]]+/\1 0027/g" "$file"
    fi
done
{{%- endif %}}
