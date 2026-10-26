#!/bin/bash
{{% if not VENDOR_DROPIN_DIRS %}}
# platform = Not Applicable
{{% else %}}
SECTION="{{{ SECTION }}}"
PARAM="{{{ PARAM }}}"
MASTER_CFG_FILE="{{{ MASTER_CFG_FILE }}}"
VENDOR_DIR="{{{ DROPIN_DIRS[-1] }}}"
mkdir -p "$VENDOR_DIR"
# The main file holds the section, and a vendor dropin that sorts after
# complianceascode_hardening.conf sets a wrong value.
echo -e "[$SECTION]" > "$MASTER_CFG_FILE"
{{% if NO_QUOTES %}}
echo -e "[$SECTION]\n$PARAM=badval" > "$VENDOR_DIR/ssg.conf"
{{% else %}}
echo -e "[$SECTION]\n$PARAM=\"badval\"" > "$VENDOR_DIR/ssg.conf"
{{% endif %}}
{{% endif %}}
