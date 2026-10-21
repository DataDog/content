import ssg.utils
import os


def preprocess(data, lang):
    path = data["path"]
    name = ssg.utils.escape_id(os.path.basename(os.path.normpath(path)))
    data["name"] = name
    if lang == "oval":
        data["path_escaped"] = path.replace("/", "\\/")
        data["path_escaped_no_slash"] = path.rstrip("/").replace("/", "\\/")
    if "key" not in data:
        data["key"] = data["_rule_id"]
    if data["path"].endswith("/"):
        data["filter_type"] = "dir"
    else:
        data["filter_type"] = "path"
    return data
