#!/usr/bin/env python3
"""Provision required grammar parity inputs at the subproject's reviewed pins."""
import argparse
import json
from pathlib import Path
import re
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("repository", type=Path)
parser.add_argument("--plan", action="store_true", help="validate and print pins without fetching")
args = parser.parse_args()
# These full tests require external inputs even with -short. Other optional
# corpus tests retain their existing applicability; no test selection changes.
required = {"cobol": "src", "javascript": "src", "typescript": "typescript/src", "tsx": "tsx/src"}
rows = {}
for line in (args.repository / "grammars/languages.lock").read_text().splitlines():
    if not line or line.startswith("#"):
        continue
    fields = line.split()
    if fields[0] not in required:
        continue
    if fields[0] in rows or len(fields) < 4:
        raise SystemExit("Duplicate or malformed grammar pin")
    name, url, commit, subdir = fields[:4]
    if not re.fullmatch(r"https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", url):
        raise SystemExit("Grammar source is not a public GitHub repository URL")
    if not re.fullmatch(r"[0-9a-f]{40}", commit) or subdir != required[name]:
        raise SystemExit("Invalid grammar revision or source path")
    rows[name] = {"name": name, "url": url, "commit": commit, "subdir": subdir}
if rows.keys() != required.keys():
    raise SystemExit("Required grammar pins are missing")
if any(rows["tsx"][key] != rows["typescript"][key] for key in ("url", "commit")):
    raise SystemExit("TSX and TypeScript must use the same reviewed source revision")
print(json.dumps(list(rows.values()), indent=2), flush=True)
if args.plan:
    raise SystemExit(0)

# These paths are the existing gotreesitter parity contract, not new defaults.
root = Path("/tmp/grammar_parity")
if root.is_symlink():
    raise SystemExit("Refusing a symlink grammar fixture root")
root.mkdir(parents=True, exist_ok=True)
for name in ("cobol", "javascript", "typescript"):
    row = rows[name]
    target = root / name
    if target.is_symlink():
        raise SystemExit("Refusing a symlink grammar fixture checkout")
    if not target.exists():
        target.mkdir()
        subprocess.run(["git", "init", str(target)], check=True)
        subprocess.run(["git", "-C", str(target), "remote", "add", "origin", row["url"]], check=True)
        subprocess.run(["git", "-C", str(target), "fetch", "--depth=1", "origin", row["commit"]], check=True)
        subprocess.run(["git", "-C", str(target), "checkout", "--detach", "FETCH_HEAD"], check=True)
    actual = subprocess.check_output(["git", "-C", str(target), "rev-parse", "HEAD"], text=True).strip()
    dirty = subprocess.check_output(["git", "-C", str(target), "status", "--porcelain", "--untracked-files=all"], text=True).strip()
    if actual != row["commit"] or dirty:
        raise SystemExit("Existing grammar fixture differs from its clean reviewed revision")
for name, row in rows.items():
    checkout = "typescript" if name == "tsx" else name
    if not (root / checkout / row["subdir"] / "grammar.json").is_file():
        raise SystemExit("Pinned grammar fixture lacks required grammar.json: " + name)
