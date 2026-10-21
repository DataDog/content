#!/bin/bash
{{% if product == "rhel7" %}}
# platform = Not Applicable
{{% endif %}}

. $SHARED/partition.sh

clean_up_partition /dev/shm
