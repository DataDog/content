# The firewall utilities of the CIS benchmarks for Debian and Ubuntu, in
# the order of their sections: ufw, nftables, and iptables with
# iptables-persistent.
UTILITIES = ["ufw", "nftables", "iptables"]


def preprocess(data, lang):
    if data["arg"] not in UTILITIES:
        raise ValueError(
            "platform deb_firewall_applicable[{0}]: the utility must be one of {1}".format(
                data["arg"], ", ".join(UTILITIES)))
    data["others"] = [u for u in UTILITIES if u != data["arg"]]
    return data
