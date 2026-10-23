#!/bin/bash
{{% if PACKAGE_FOR_TESTING %}}
# packages = {{{ PACKAGE_FOR_TESTING }}}
{{% endif %}}
SECTION="{{{ SECTION }}}"
PARAM="{{{ PARAM }}}"
VALUE="{{{ VALUE }}}"
DROPIN_DIR="{{{ DROPIN_DIR }}}"
[ -d $DROPIN_DIR ] || mkdir -p $DROPIN_DIR
# The last assignment of the file is the one in effect.
{{% if NO_QUOTES %}}
echo -e "[$SECTION]\n$PARAM=$VALUE\n$PARAM=badval" > "$DROPIN_DIR/ssg.conf"
{{% else %}}
echo -e "[$SECTION]\n$PARAM=\"$VALUE\"\n$PARAM=\"badval\"" > "$DROPIN_DIR/ssg.conf"
{{% endif %}}
