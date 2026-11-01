#!/usr/bin/env python3
"""Provision public runtime fixtures; never run or vendor their test code."""

import argparse
import hashlib
import io
import pathlib
import re
import shutil
import subprocess
import tarfile
import tempfile
import urllib.error
import urllib.request


SOURCES = (
    (".dash-tests", "https://git.kernel.org/pub/scm/utils/dash/dash.git",
     "552c2b2f679d191a9de93cebcfb36581a2a87a4c", "src/funcs"),
    (".modernish-tests", "https://github.com/modernish/modernish.git",
     "cde49fa37f93e943b9cb9b9536ce83836c4864ae", "bin/modernish"),
    ("priorart/oils", "https://github.com/oils-for-unix/oils.git",
     "15de8fd779569e6e3a9f5fcbfc00e7df0ebe0380", "spec"),
    (".yash-tests", "https://github.com/magicant/yash.git",
     "0105ae707bce655034522372f8b2a20072819c28", "tests"),
)


def extract_bash(data, destination, digest):
    if hashlib.sha256(data).hexdigest() != digest:
        raise ValueError("GNU Bash archive checksum mismatch")
    with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
        for member in archive:
            parts = pathlib.PurePosixPath(member.name).parts
            if len(parts) < 3 or parts[:2] not in (
                    ("bash-5.3", "tests"), ("bash-5.3", "support")):
                continue
            if ".." in parts or member.issym() or member.islnk():
                raise ValueError("unsafe GNU Bash fixture archive member")
            target = destination.joinpath(*parts[1:])
            if member.isdir():
                target.mkdir(parents=True, exist_ok=True)
            elif member.isfile():
                target.parent.mkdir(parents=True, exist_ok=True)
                with archive.extractfile(member) as source, target.open("wb") as output:
                    shutil.copyfileobj(source, output)
                target.chmod(member.mode & 0o777)
    for required in ("tests/run-all", "support/recho.c"):
        if not (destination / required).is_file():
            raise ValueError("GNU Bash archive lacks " + required)
    (destination / ".bashy-source-sha256").write_text(digest + "\n")


def bash53(root):
    # Match the subproject's download contract; fail if its format changes.
    contract = (root / "internal/agentos/verify.go").read_text()
    hashes = re.findall(r'const bash53TarballSHA256 = "([0-9a-f]{64})"', contract)
    origins = re.findall(r'const bash53TarballURL = "(https://[^"]+)"', contract)
    if len(hashes) != 1 or len(origins) != 1:
        raise ValueError("cannot resolve Bashy's GNU fixture source contract")
    digest = hashes[0]
    destination = root / "external/bash-5.3"
    marker = destination / ".bashy-source-sha256"
    if destination.exists() or destination.is_symlink():
        if (marker.is_file() and marker.read_text().strip() == digest
                and (destination / "tests/run-all").is_file()
                and (destination / "support/recho.c").is_file()):
            print("GNU Bash fixture cache matches " + digest, flush=True)
            return
        raise ValueError("existing GNU fixture tree lacks matching provenance; use a clean runner")
    urls = ("https://mirrors.kernel.org/gnu/bash/bash-5.3.tar.gz",
            "https://ftpmirror.gnu.org/bash/bash-5.3.tar.gz", origins[0])
    destination.parent.mkdir(parents=True, exist_ok=True)
    errors = []
    for url in urls:
        try:
            print("Fetching " + url, flush=True)
            with urllib.request.urlopen(url, timeout=30) as response:
                data = response.read()
            with tempfile.TemporaryDirectory(dir=destination.parent) as scratch:
                staging = pathlib.Path(scratch) / "fixtures"
                staging.mkdir()
                extract_bash(data, staging, digest)
                staging.rename(destination)
            print("GNU Bash fixture SHA256 " + digest, flush=True)
            return
        except (OSError, urllib.error.URLError, ValueError, tarfile.TarError) as error:
            errors.append(url + ": " + str(error))
    raise RuntimeError("No verified GNU Bash mirror succeeded:\n" + "\n".join(errors))


def free_suites(root):
    for relative, url, revision, required in SOURCES:
        destination = root / relative
        if destination.exists():
            raise ValueError("fixture destination already exists: " + relative)
        destination.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(["git", "init", str(destination)], check=True)
        subprocess.run(["git", "-C", str(destination), "remote", "add", "origin", url], check=True)
        subprocess.run(["git", "-C", str(destination), "fetch", "--depth=1", "origin", revision], check=True)
        subprocess.run(["git", "-C", str(destination), "checkout", "--detach", "FETCH_HEAD"], check=True)
        actual = subprocess.check_output(["git", "-C", str(destination), "rev-parse", "HEAD"], text=True).strip()
        if actual != revision or not (destination / required).exists():
            raise ValueError("fixture identity or required corpus missing: " + relative)
        print(relative + " " + actual, flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("kind", choices=("bash53", "free-posix"))
    parser.add_argument("root", type=pathlib.Path)
    arguments = parser.parse_args()
    if arguments.kind == "bash53":
        bash53(arguments.root.resolve())
    else:
        free_suites(arguments.root.resolve())
