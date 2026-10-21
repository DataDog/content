#!/bin/bash
# platform = Ubuntu 20.04
# packages = nftables

nft flush ruleset
nft create table ip filter
