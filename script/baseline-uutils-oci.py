#!/usr/bin/env python3
"""Retain only the current uutils invocation's owned output, without changing Docker's exit."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import sys

args = sys.argv[1:]
result = subprocess.run(["docker", *args], check=False)
if args and args[0] == "run":
    evidence = Path(os.environ["UUTILS_CAPTURE_DIR"])
    evidence.mkdir(parents=True, exist_ok=True)
    try:
        mounts = {}
        for index, arg in enumerate(args[:-1]):
            if arg != "--mount":
                continue
            fields = dict(part.split("=", 1) for part in args[index + 1].split(",") if "=" in part)
            if fields.get("type") == "bind" and fields.get("dst") in ("/out", "/input/uutils.tar"):
                if fields["dst"] in mounts:
                    raise ValueError("duplicate owned mount")
                mounts[fields["dst"]] = Path(fields["src"])
        output = mounts["/out"]
        archive = mounts["/input/uutils.tar"]
        work_root = Path(os.environ["UUTILS_CAPTURE_WORK_ROOT"]).resolve(strict=True)
        work = output.parent
        if (output.name != "out" or archive != work / "uutils.tar"
                or work.parent.resolve(strict=True) != work_root
                or not work.name.startswith("bashy-uutils.")
                or work.is_symlink() or output.is_symlink() or archive.is_symlink()
                or work.stat().st_uid != os.getuid() or not archive.is_file()
                or not output.is_dir()):
            raise ValueError("output is not this invocation's owned work directory")
        receipt = {"docker_exit": result.returncode, "files": {}}
        for name in ("list.txt", "run.txt"):
            source = output / name
            if not stat.S_ISREG(source.lstat().st_mode):
                raise ValueError("refusing nonregular output " + name)
            target = evidence / name
            shutil.copyfile(source, target)
            receipt["files"][name] = hashlib.sha256(target.read_bytes()).hexdigest()
        (evidence / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
    except (OSError, ValueError, KeyError) as error:
        (evidence / "capture-error.txt").write_text(str(error) + "\n")
        print("uutils raw evidence capture failed: " + str(error), file=sys.stderr)
# Preserve signal termination as well as ordinary Docker exit status.
if result.returncode < 0:
    import signal
    if -result.returncode not in (signal.SIGKILL, signal.SIGSTOP):
        signal.signal(-result.returncode, signal.SIG_DFL)
    os.kill(os.getpid(), -result.returncode)
sys.exit(result.returncode)
