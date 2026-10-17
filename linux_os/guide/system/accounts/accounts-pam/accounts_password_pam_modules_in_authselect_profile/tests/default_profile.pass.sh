#!/bin/bash
# platform = multi_platform_all

# The default sssd profile includes the four modules.
authselect select sssd --force
authselect apply-changes
