# The firewall utilities that the CIS benchmarks for RHEL and its
# derivatives name, with the package of each and the systemd services it
# runs. A utility is in use when its package is installed and one of its
# services is enabled.
UTILITIES = [
    {"name": "firewalld", "package": "firewalld", "services": ["firewalld"]},
    {"name": "nftables", "package": "nftables", "services": ["nftables"]},
    {"name": "iptables", "package": "iptables-services", "services": ["iptables", "ip6tables"]},
]


def preprocess(data, lang):
    names = [u["name"] for u in UTILITIES]
    if data["utility"] not in names:
        raise ValueError(
            "template firewall_utility_installed: the utility must be one of {0}, not {1}".format(
                ", ".join(names), data["utility"]))
    data["package"] = [u for u in UTILITIES if u["name"] == data["utility"]][0]["package"]
    data["others"] = [u for u in UTILITIES if u["name"] != data["utility"]]
    return data
