from ssg.utils import parse_template_boolean_value


def preprocess(data, lang):
    data["missing_parameter_pass"] = parse_template_boolean_value(
        data, parameter="missing_parameter_pass", default_value=False)
    data["no_quotes"] = parse_template_boolean_value(
        data, parameter="no_quotes", default_value=False)
    data["missing_config_file_fail"] = parse_template_boolean_value(
        data, parameter="missing_config_file_fail", default_value=True)
    data["vendor_dropin_dirs"] = parse_template_boolean_value(
        data, parameter="vendor_dropin_dirs", default_value=False)
    data["missing_parameter_pass_definition"] = data.get("missing_parameter_pass_definition", "")
    data["dropin_dirs"] = []
    if data["vendor_dropin_dirs"]:
        dropin_dir = data["dropin_dir"]
        if not dropin_dir.startswith("/etc/"):
            raise ValueError(
                "vendor_dropin_dirs requires a dropin_dir under /etc/, got %s" % dropin_dir)
        rel = dropin_dir[len("/etc/"):]
        data["dropin_dirs"] = [dropin_dir] + [
            prefix + rel for prefix in ("/run/", "/usr/local/lib/", "/usr/lib/")]
    return data
