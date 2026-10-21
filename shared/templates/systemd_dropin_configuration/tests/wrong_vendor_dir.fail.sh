#!/bin/bash
{{% if PACKAGE_FOR_TESTING %}}
# packages = {{{ PACKAGE_FOR_TESTING }}}
{{% endif %}}
{{% if not VENDOR_DROPIN_DIRS %}}
# platform = Not Applicable
{{% else %}}
# remediation = none
SECTION="{{{ SECTION }}}"
PARAM="{{{ PARAM }}}"
VALUE="{{{ VALUE }}}"
MASTER_CFG_FILE="{{{ MASTER_CFG_FILE }}}"
VENDOR_DIR="{{{ DROPIN_DIRS[-1] }}}"
mkdir -p "$VENDOR_DIR"
# A dropin overrides the main file, wherever the dropin lives.
{{% if NO_QUOTES %}}
echo -e "[$SECTION]\n$PARAM=$VALUE" > "$MASTER_CFG_FILE"
echo -e "[$SECTION]\n$PARAM=badval" > "$VENDOR_DIR/ssg.conf"
{{% else %}}
echo -e "[$SECTION]\n$PARAM=\"$VALUE\"" > "$MASTER_CFG_FILE"
echo -e "[$SECTION]\n$PARAM=\"badval\"" > "$VENDOR_DIR/ssg.conf"
{{% endif %}}
{{% endif %}}
