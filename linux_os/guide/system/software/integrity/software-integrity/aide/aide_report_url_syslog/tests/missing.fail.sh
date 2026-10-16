#!/bin/bash
# packages = aide

sed -i '/^[[:space:]]*report_url[[:space:]]*=/d' {{{ aide_conf_path }}}
