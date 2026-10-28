#!/bin/bash

source common.sh

chmod 0604 /home/dummy/.bash_history
# The user listed last has no history file.
useradd -m nohistory
rm -f /home/nohistory/.bash_history
