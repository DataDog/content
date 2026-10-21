#!/bin/bash
# platform = multi_platform_ubuntu
# check-import = stdout

# ufw passes when it is absent, or inactive with its service masked and
# stopped.
if ! command -v ufw >/dev/null 2>&1; then
    exit "$XCCDF_RESULT_PASS"
fi
if ufw status 2>/dev/null | grep -q '^Status: active'; then
    exit "$XCCDF_RESULT_FAIL"
fi
if [ "$(systemctl is-enabled ufw.service 2>/dev/null)" != "masked" ]; then
    exit "$XCCDF_RESULT_FAIL"
fi
if systemctl is-active --quiet ufw.service; then
    exit "$XCCDF_RESULT_FAIL"
fi
exit "$XCCDF_RESULT_PASS"
