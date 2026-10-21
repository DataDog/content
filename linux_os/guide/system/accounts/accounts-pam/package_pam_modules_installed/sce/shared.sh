#!/bin/bash
# platform = Ubuntu 20.04
# check-import = stdout
# check-export = var_package_latest_version_required=var_package_latest_version_required

# With var_package_latest_version_required, as CIS Ubuntu 20.04 5.3.1 sets
# it, apt list --upgradable, which reads the local package lists, must offer
# no newer version of the package. apt needs a writable /tmp to read them.
if ! {{{ bash_package_installed("libpam-modules") }}}; then
    echo 'libpam-modules is not installed.'
    exit "$XCCDF_RESULT_FAIL"
fi

if [ "$XCCDF_VALUE_var_package_latest_version_required" = true ]; then
    if ! upgradable=$(apt list --upgradable 2>/dev/null); then
        echo 'apt list --upgradable cannot read the package lists.'
        exit "$XCCDF_RESULT_ERROR"
    fi
    if printf '%s\n' "$upgradable" | grep -q '^libpam-modules/'; then
        echo 'An upgrade is available for libpam-modules.'
        exit "$XCCDF_RESULT_FAIL"
    fi
fi

exit "$XCCDF_RESULT_PASS"
