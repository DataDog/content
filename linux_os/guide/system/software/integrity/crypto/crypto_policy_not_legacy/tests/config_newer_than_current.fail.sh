#!/bin/bash
# packages = crypto-policies-scripts

update-crypto-policies --set DEFAULT
sleep 1s
touch /etc/crypto-policies/config
