#!/usr/bin/env python3
"""Record the exact public candidate before a manual validation lane runs."""
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import tarfile

root = Path(__file__).resolve().parent.parent

def git(*args):
    return subprocess.check_output(["git", "-C", str(root), *args], text=True).strip()

evidence = Path(os.environ["EVIDENCE_DIR"])
evidence.mkdir(parents=True, exist_ok=True)
if sys.argv[1:] == ["--prepare-candidate"]:
    binary = root / "bashy/bin/bashy"
    digest = hashlib.sha256(binary.read_bytes()).hexdigest()
    # Relative paths resolve from bashsharp-tests, the established gate cwd.
    paths = git("config", "--file", ".gitmodules", "--get-regexp", "path").splitlines()
    repositories = []
    for entry in paths:
        path = entry.split(None, 1)[1]
        if path == "bashsharp-tests":
            continue  # The registry may advance after review; product sources may not.
        commit = subprocess.check_output(["git", "-C", str(root / path), "rev-parse", "HEAD"], text=True).strip()
        repositories.append({"path": "../" + path, "commit": commit})
    repositories.sort(key=lambda item: item["path"])
    recipe = "env GOTOOLCHAIN=go1.27.2 GOMAXPROCS=2 GOFLAGS=-p=2 GOWORK=<umbrella>/go.work make build-bashy"
    candidate = {"launcher_sha256": digest, "payload_sha256": digest,
                 "frontend_version": "gosource-v1", "build_recipe": recipe,
                 "repositories": repositories}
    manifest_path = evidence / "gbe-candidate.json"
    manifest_path.write_text(json.dumps(candidate, indent=2) + "\n")
    identity = subprocess.check_output(["go", "version"], text=True).strip()
    goos, goarch = subprocess.check_output(["go", "env", "GOOS", "GOARCH"], text=True).split()
    registry = [goos, goarch, hashlib.sha256(manifest_path.read_bytes()).hexdigest(),
                digest, digest, "gosource-v1", identity, recipe,
                ";".join(Path(item["path"]).name + "=" + item["commit"] for item in repositories)]
    (evidence / "UNAPPROVED-candidate-row.tsv").write_text("\t".join(registry) + "\n")
    goroot = subprocess.check_output(["go", "env", "GOROOT"], text=True).strip()
    sdk = Path(goroot) / "bin/go"
    (evidence / "build-toolchain.json").write_text(json.dumps({
        "identity": identity, "go_bin_sha256": hashlib.sha256(sdk.read_bytes()).hexdigest(),
        "approval": "Compare independently with docs/go-by-example/build-toolchains.tsv"}, indent=2) + "\n")
    (evidence / "binary-build-info.txt").write_text(subprocess.check_output(["go", "version", "-m", str(binary)], text=True))
    with tarfile.open(evidence / "candidate-binaries.tar", "w") as archive:
        archive.add(binary, arcname="bin/bashy")
    raise SystemExit(0)

if sys.argv[1:] == ["--artifacts"]:
    hashes = {}
    for name in ("bash", "bash.real", "bash.exe", "bashy", "bashy.real", "bashy.exe", "sh", "sh.real", "sh.exe"):
        path = root / "bashy" / "bin" / name
        if path.is_file():
            hashes[str(path.relative_to(root))] = hashlib.sha256(path.read_bytes()).hexdigest()
    (evidence / "artifact-sha256.json").write_text(json.dumps(hashes, indent=2) + "\n")
    raise SystemExit(0)

pins = git("submodule", "status", "--recursive").splitlines()
if any(line.startswith(("-", "+", "U")) for line in pins):
    raise SystemExit("Candidate submodules are missing, conflicted, or differ from their gitlinks")
if git("status", "--porcelain=v1", "--untracked-files=no", "--ignore-submodules=untracked"):
    raise SystemExit("Candidate has tracked changes in the root or nested submodules")
# Explicit recursive checks also catch staged changes inside nested repositories.
subprocess.run(["git", "-C", str(root), "submodule", "foreach", "--quiet", "--recursive",
                'test -z "$(git status --porcelain=v1 --untracked-files=no --ignore-submodules=untracked)"'],
               check=True)
manifest = {
    "umbrella_sha": git("rev-parse", "HEAD"),
    "submodule_pins": pins,
    "go_version": subprocess.check_output(["go", "version"], text=True).strip(),
    "runner_os": os.environ.get("RUNNER_OS", platform.system()),
    "arch": platform.machine(),
    "lane": os.environ.get("VALIDATION_LANE", "unspecified"),
    "dependency_mode": os.environ.get("DEPENDENCY_MODE", "workspace"),
    "run_id": os.environ.get("GITHUB_RUN_ID", "local"),
    "run_attempt": os.environ.get("GITHUB_RUN_ATTEMPT", "local"),
    "coverage": "Per-lane evidence only; consult coverage.md and every job result.",
}
(evidence / "candidate.json").write_text(json.dumps(manifest, indent=2) + "\n")
print(json.dumps(manifest, indent=2))
