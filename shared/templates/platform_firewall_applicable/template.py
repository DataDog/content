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
    if data["arg"] not in names:
        raise ValueError(
            "platform firewall_applicable[{0}]: the utility must be one of {1}".format(
                data["arg"], ", ".join(names)))
    data["utilities"] = UTILITIES
    data["others"] = [u for u in UTILITIES if u["name"] != data["arg"]]
    data["utility"] = [u for u in UTILITIES if u["name"] == data["arg"]][0]
    return data
