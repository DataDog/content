import pytest

from tests.ssg_test_suite import common
from tests.ssg_test_suite.log import LogHelper

RHEL8_CPE = 'CPE_NAME="cpe:/o:redhat:enterprise_linux:8::baseos"'


class RecordingTestEnv:
    """Stands in for a test environment, reporting the packages named in
    `unavailable` the way a package manager reports ones its repositories
    don't carry, and keeping every install command it was given"""
    def __init__(self, unavailable=()):
        self.unavailable = set(unavailable)
        self.commands = []

    def execute_ssh_command(self, command, log_file, error_msg_template=None):
        if "CPE_NAME" in command:
            return RHEL8_CPE
        self.commands.append(command)
        asked_for = set(command.split()) & self.unavailable
        if asked_for:
            raise RuntimeError("No match for argument: %s" % ",".join(asked_for))
        return ""


@pytest.fixture(autouse=True)
def log_dir(tmp_path):
    previous = LogHelper.LOG_DIR
    LogHelper.LOG_DIR = str(tmp_path)
    yield
    LogHelper.LOG_DIR = previous


def test_install_packages():
    test_env = RecordingTestEnv()
    assert common.install_packages(test_env, {"sudo", "pam"}) == set()
    assert len(test_env.commands) == 1


def test_install_packages_unavailable():
    test_env = RecordingTestEnv({"authselect"})
    assert common.install_packages(
        test_env, {"authselect", "pam"}) == {"authselect"}
    assert "yum install -y pam" in test_env.commands


def test_install_packages_all_unavailable():
    test_env = RecordingTestEnv({"authselect", "aide"})
    assert common.install_packages(
        test_env, {"authselect", "aide"}) == {"authselect", "aide"}
