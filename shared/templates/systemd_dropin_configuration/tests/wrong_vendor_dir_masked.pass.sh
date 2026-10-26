#!/bin/bash
{{% if not VENDOR_DROPIN_DIRS %}}
# platform = Not Applicable
{{% else %}}
SECTION="{{{ SECTION }}}"
PARAM="{{{ PARAM }}}"
VALUE="{{{ VALUE }}}"
DROPIN_DIR="{{{ DROPIN_DIR }}}"
RUN_DIR="{{{ DROPIN_DIRS[1] }}}"
VENDOR_DIR="{{{ DROPIN_DIRS[-1] }}}"
mkdir -p "$DROPIN_DIR" "$RUN_DIR" "$VENDOR_DIR"
# A dropin masks the dropins of the same name in the directories read
# after its own.
{{% if NO_QUOTES %}}
echo -e "[$SECTION]\n$PARAM=badval" > "$VENDOR_DIR/ssg.conf"
echo -e "[$SECTION]\n$PARAM=$VALUE" > "$DROPIN_DIR/ssg.conf"
echo -e "[$SECTION]\n$PARAM=badval" > "$VENDOR_DIR/gss.conf"
echo -e "[$SECTION]\n$PARAM=$VALUE" > "$RUN_DIR/gss.conf"
{{% else %}}
echo -e "[$SECTION]\n$PARAM=\"badval\"" > "$VENDOR_DIR/ssg.conf"
echo -e "[$SECTION]\n$PARAM=\"$VALUE\"" > "$DROPIN_DIR/ssg.conf"
echo -e "[$SECTION]\n$PARAM=\"badval\"" > "$VENDOR_DIR/gss.conf"
echo -e "[$SECTION]\n$PARAM=\"$VALUE\"" > "$RUN_DIR/gss.conf"
{{% endif %}}
{{% endif %}}
