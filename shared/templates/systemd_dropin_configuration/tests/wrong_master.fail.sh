#!/bin/bash
SECTION="{{{ SECTION }}}"
PARAM="{{{ PARAM }}}"
MASTER_CFG_FILE="{{{ MASTER_CFG_FILE }}}"
{{% for dir in DROPIN_DIRS[1:] %}}
sed -i "/^\\s*$PARAM\\s*=/d" {{{ dir }}}/*.conf 2>/dev/null || true
{{% endfor %}}
{{% if NO_QUOTES %}}
echo -e "[$SECTION]\n$PARAM=badval" > "$MASTER_CFG_FILE"
{{% else %}}
echo -e "[$SECTION]\n$PARAM=\"badval\"" > "$MASTER_CFG_FILE"
{{% endif %}}
