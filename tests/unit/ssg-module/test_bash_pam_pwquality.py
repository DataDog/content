import os
import subprocess
import types

import pytest

import ssg.jinja


def write_command(path, text):
    path.write_text("#!/bin/sh\n" + text)
    path.chmod(0o755)


@pytest.fixture
def pwquality_helper(tmp_path, monkeypatch):
    """Run the actual helper with its files and its package and PAM commands isolated.

    dpkg-query reports libpam-pwquality installed while the installed file
    exists. apt-get writes its arguments to that file, and fails while the
    offline file exists. pam-auth-update logs each run to the calls file.
    """
    profile_dir = tmp_path / "pam-configs"
    profile_dir.mkdir()
    bin_dir = tmp_path / "bin"
    bin_dir.mkdir()
    helper = types.SimpleNamespace(
        profile=profile_dir / "cac_pwquality",
        installed=tmp_path / "installed",
        offline=tmp_path / "offline",
        calls=tmp_path / "calls")
    write_command(bin_dir / "dpkg-query",
                  '[ ! -e "%s" ] || echo installed\n' % helper.installed)
    write_command(bin_dir / "apt-get",
                  '[ ! -e "%s" ] || exit 100\necho "$*" >"%s"\n'
                  % (helper.offline, helper.installed))
    write_command(bin_dir / "pam-auth-update", 'echo "$*" >>"%s"\n' % helper.calls)
    helper.installed.touch()

    # Keep product-specific macros in other tests independent of this helper.
    monkeypatch.setattr(ssg.jinja, "_jinja_env", None)
    macros = ssg.jinja.load_macros({"pkg_manager": "apt_get"})
    script = str(macros["bash_pam_pwquality_enable"]()).replace(
        "/usr/share/pam-configs", str(profile_dir))
    env = dict(os.environ, PATH=str(bin_dir) + os.pathsep + os.environ["PATH"])

    def run(flags="-eu"):
        subprocess.run(["bash", flags], input=script, universal_newlines=True,
                       env=env, check=True)

    helper.run = run
    return helper


def test_new_profile_preserves_retry_requirement(pwquality_helper):
    helper = pwquality_helper
    helper.run()

    assert "pam_pwquality.so retry=3" in helper.profile.read_text()
    assert helper.profile.stat().st_mode & 0o777 == 0o644

    original = helper.profile.read_bytes()
    helper.run()
    assert helper.profile.read_bytes() == original


def test_existing_profile_preserves_stricter_settings(pwquality_helper):
    helper = pwquality_helper
    original = "Password:\n    requisite pam_pwquality.so retry=1 enforce_for_root\n"
    helper.profile.write_text(original)
    helper.run()

    assert helper.profile.read_text() == original


def test_missing_package_is_installed_before_profile(pwquality_helper):
    helper = pwquality_helper
    helper.installed.unlink()
    helper.run()

    assert "install -y libpam-pwquality" in helper.installed.read_text()
    assert "pam_pwquality.so retry=3" in helper.profile.read_text()
    assert helper.calls.exists()


def test_failed_install_leaves_profile_disabled(pwquality_helper):
    helper = pwquality_helper
    helper.installed.unlink()
    helper.offline.touch()
    # oscap runs a fix with bash without -e, so the helper goes on after
    # apt-get fails.
    helper.run("-u")

    assert not helper.profile.exists()
    assert not helper.calls.exists()
