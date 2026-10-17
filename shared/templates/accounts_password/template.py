# The pwquality default meets a requirement "value OPERATION variable" when
# "variable DEFAULT_OPERATION default" holds.
DEFAULT_OPERATIONS = {
    "equals": "equals",
    "greater than or equal": "less than or equal",
    "less than or equal": "greater than or equal",
}


def preprocess(data, lang):
    data["zero_comparison_operation"] = data.get("zero_comparison_operation", None)
    data["pwquality_default"] = data.get("pwquality_default", None)
    if data["pwquality_default"] is not None:
        if data["zero_comparison_operation"] or data["operation"] not in DEFAULT_OPERATIONS:
            raise ValueError(
                "pwquality_default works with the operations %s, and conflicts "
                "with zero_comparison_operation" % ", ".join(map(repr, DEFAULT_OPERATIONS)))
        data["default_operation"] = DEFAULT_OPERATIONS[data["operation"]]

    if "greater" in data["operation"]:
        if data["zero_comparison_operation"]:
            if "greater" in data["zero_comparison_operation"]:
                data["test_var_value"] = "-2"
                data["test_correct_value"] = "1"
                data["test_wrong_value"] = "-3"
                data["test_wrong_vs_zero_value"] = "-1"
            elif "less" in data["zero_comparison_operation"]:
                data["test_var_value"] = "-2"
                data["test_correct_value"] = "-1"
                data["test_wrong_value"] = "-3"
                data["test_wrong_vs_zero_value"] = "1"
        else:
            data["test_var_value"] = "0"
            data["test_correct_value"] = "1"
            data["test_wrong_value"] = "-1"

    elif "less" in data["operation"]:
        if data["zero_comparison_operation"]:
            if "greater" in data["zero_comparison_operation"]:
                data["test_var_value"] = "2"
                data["test_correct_value"] = "1"
                data["test_wrong_value"] = "3"
                data["test_wrong_vs_zero_value"] = "-1"
            elif "less" in data["zero_comparison_operation"]:
                data["test_var_value"] = "2"
                data["test_correct_value"] = "-1"
                data["test_wrong_value"] = "3"
                data["test_wrong_vs_zero_value"] = "1"
        else:
            data["test_var_value"] = "0"
            data["test_correct_value"] = "-1"
            data["test_wrong_value"] = "1"
    else:
        data["test_var_value"] = "0"
        data["test_correct_value"] = "0"
        data["test_wrong_value"] = "1"

    return data
