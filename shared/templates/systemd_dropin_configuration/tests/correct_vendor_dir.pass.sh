#!/bin/bash
{{% if PACKAGE_FOR_TESTING %}}
# packages = {{{ PACKAGE_FOR_TESTING }}}
{{% endif %}}
{{% if not VENDOR_DROPIN_DIRS %}}
# platform = Not Applicable
{{% else %}}
SECTION="{{{ SECTION }}}"
PARAM="{{{ PARAM }}}"
VALUE="{{{ VALUE }}}"
VENDOR_DIR="{{{ DROPIN_DIRS[-1] }}}"
mkdir -p "$VENDOR_DIR"
{{% if NO_QUOTES %}}
echo -e "[$SECTION]\n$PARAM=$VALUE" > "$VENDOR_DIR/ssg.conf"
{{% else %}}
echo -e "[$SECTION]\n$PARAM=\"$VALUE\"" > "$VENDOR_DIR/ssg.conf"
{{% endif %}}
{{% endif %}}
