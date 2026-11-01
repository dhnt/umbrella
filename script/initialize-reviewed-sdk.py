#!/usr/bin/env python3
"""Initialize Go's module SDK using the Go 1.27.2 toolchain/select.go recipe.

Authenticate bin/go before chmod or execution. Preserve payload bytes and directory
modes; copy nested _go.mod files before publishing src/go.mod as the ready marker.
"""
import fnmatch
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess
import sys
import tempfile

VERSION = "go1.27.2"
PINS = Path(__file__).resolve().parents[1] / "bashsharp-tests/docs/go-by-example/build-toolchains.tsv"


def regular(path):
    if not stat.S_ISREG(path.lstat().st_mode):
        raise ValueError(f"expected regular SDK file: {path}")
    return path


def initialize(root, goos, goarch, pins=PINS):
    coordinate = f"v0.0.1-{VERSION}.{goos}-{goarch}"
    if root.name != "toolchain@" + coordinate or root.is_symlink():
        raise ValueError("SDK directory does not match exact reviewed coordinate")
    rows = [line.split("\t") for line in pins.read_text().splitlines()
            if line and not line.startswith("#")]
    matches = [row for row in rows if row[:3] == [goos, goarch, VERSION]]
    if len(matches) != 1 or len(matches[0]) != 8:
        raise ValueError("missing or ambiguous reviewed SDK coordinate")
    # Reject links before touching any mode or executing payload bytes.
    files = []
    for directory, dirs, names in os.walk(root, followlinks=False):
        for name in dirs + names:
            path = Path(directory) / name
            if path.is_symlink():
                raise ValueError(f"unexpected SDK symlink: {path}")
        files.extend(regular(Path(directory) / name) for name in names)
    go = regular(root / "bin" / ("go.exe" if goos == "windows" else "go"))
    digest = hashlib.sha256(go.read_bytes()).hexdigest()
    if digest != matches[0][4]:
        raise ValueError("reviewed bin/go SHA-256 mismatch")
    src = regular(root / "src/_go.mod")
    if goos != "windows":
        # Repair even a partially initialized cache; always publish bin/go last.
        groups = [
            [p for p in files if p.is_relative_to(root / "pkg/tool")],
            [p for p in files if p.is_relative_to(root / "lib")
             and fnmatch.fnmatchcase(p.name, "go_?*_?*_exec")],
            [regular(root / "bin/gofmt")],
            [p for p in files if p.is_relative_to(root / "bin") and p != go],
            [go],
        ]
        for group in groups:
            for path in group:
                path.chmod(stat.S_IMODE(path.stat().st_mode) | 0o111)
    modules = sorted(p for p in files if p.name == "_go.mod" and p != src)
    for path in modules + [src]:
        target = path.with_name("go.mod")
        data = path.read_bytes()
        if target.exists() and regular(target).read_bytes() == data:
            continue
        directory_mode = stat.S_IMODE(path.parent.stat().st_mode)
        temporary = None
        try:
            path.parent.chmod(directory_mode | stat.S_IWUSR)
            fd, temporary = tempfile.mkstemp(prefix=".go.mod-", dir=path.parent)
            with os.fdopen(fd, "wb") as out:
                out.write(data)
            os.chmod(temporary, stat.S_IMODE(path.stat().st_mode))
            os.replace(temporary, target)
            temporary = None
        finally:
            if temporary is not None:
                os.unlink(temporary)
            path.parent.chmod(directory_mode)
    return go, matches[0][3], digest


def main():
    evidence = Path(sys.argv[1]).resolve()
    evidence.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, GOWORK="off")
    host = json.loads(subprocess.check_output(["go", "env", "-json", "GOOS", "GOARCH"], env=env, timeout=30))
    goos, goarch = host["GOOS"], host["GOARCH"]
    coordinate = f"v0.0.1-{VERSION}.{goos}-{goarch}"
    download = subprocess.run(["go", "mod", "download", "-json", "golang.org/toolchain@" + coordinate],
                              cwd=evidence, env=env, stdout=subprocess.PIPE, check=False, timeout=300)
    (evidence / "shell-reviewed-sdk-download.json").write_bytes(download.stdout)
    download.check_returncode()
    record = json.loads(download.stdout)
    if record.get("Path") != "golang.org/toolchain" or record.get("Version") != coordinate or record.get("Error"):
        raise ValueError("download returned a different SDK coordinate or an error")
    root = Path(record["Dir"])
    if not root.is_absolute():
        raise ValueError("SDK download directory must be absolute")
    go, identity, digest = initialize(root, goos, goarch)
    env.update(GOROOT=str(root), GOTOOLCHAIN="local")
    versions = []
    for args, expected in [(["version"], identity), (["tool", "compile", "-V"], "compile version " + VERSION)]:
        result = subprocess.run([str(go), *args], cwd=evidence, env=env,
                                capture_output=True, text=True, timeout=30, check=True)
        if result.stdout.strip() != expected or result.stderr:
            raise ValueError(f"SDK preflight mismatch: {result.stdout!r} {result.stderr!r}")
        versions.append(result.stdout.strip())
    report = dict(coordinate=coordinate, root=str(root), go_sha256=digest, preflight=versions)
    (evidence / "shell-reviewed-sdk-initialized.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report))


if __name__ == "__main__":
    main()
