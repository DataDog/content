#!/bin/bash
# packages = aide

sed -i '/^[[:space:]]*report_url[[:space:]]*=/d' {{{ aide_conf_path }}}
echo "report_url=file:/var/log/aide/aide.log" >> {{{ aide_conf_path }}}
echo "report_url=stdout" >> {{{ aide_conf_path }}}
