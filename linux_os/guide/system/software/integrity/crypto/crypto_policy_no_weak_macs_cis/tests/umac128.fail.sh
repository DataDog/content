#!/bin/bash
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 10
# packages = crypto-policies-scripts

# The CIS Benchmarks for these products count UMAC-128 as weak.
update-crypto-policies --set DEFAULT
