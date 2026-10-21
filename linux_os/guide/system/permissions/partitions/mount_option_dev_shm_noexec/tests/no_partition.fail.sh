#!/bin/bash
{{% if product in ["rhel7", "ubuntu2004"] %}}
# platform = Not Applicable
{{% endif %}}

. $SHARED/partition.sh

clean_up_partition /dev/shm
