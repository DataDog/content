# platform = multi_platform_ubuntu

{{% if product == "ubuntu2404" %}}
{{{ bash_set_journal_tmpfiles(2755) }}}
{{% else %}}
{{{ bash_set_journal_tmpfiles(2750) }}}
{{% endif %}}
