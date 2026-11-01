#!/usr/bin/env python3
"""Synthetic SDK initialization checks; never download or execute an SDK."""
import hashlib
import importlib.util
from pathlib import Path
import stat
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("sdk", Path(__file__).with_name("initialize-reviewed-sdk.py"))
sdk = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sdk)


class SDKInitialization(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.cleanup)
        base = Path(self.temp.name)
        self.root = base / "toolchain@v0.0.1-go1.27.2.linux-amd64"
        payloads = {
            "bin/go": b"reviewed-go", "bin/gofmt": b"gofmt",
            "pkg/tool/linux_amd64/compile": b"compile", "pkg/tool/linux_amd64/link": b"link",
            "lib/wasm/go_js_wasm_exec": b"exec", "lib/wasm/wasm_exec.js": b"javascript",
            "src/_go.mod": b"module std\n", "src/cmd/_go.mod": b"module cmd\n",
            "src/other.go": b"package other\n",
        }
        for name, data in payloads.items():
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
            path.chmod(0o444)
        self.originals = {self.root / name: data for name, data in payloads.items()}
        self.dirs = [self.root] + [p for p in self.root.rglob("*") if p.is_dir()]
        for path in self.dirs:
            path.chmod(0o555)
        self.pins = base / "pins.tsv"
        digest = hashlib.sha256(payloads["bin/go"]).hexdigest()
        self.pins.write_text("\t".join(["linux", "amd64", "go1.27.2", "go version go1.27.2 linux/amd64", digest, "archive", "digest", "source"]) + "\n")

    def cleanup(self):
        for path in self.dirs:
            if path.exists():
                path.chmod(0o755)
        self.temp.cleanup()

    def test_initialization_order_bytes_modes_and_idempotence(self):
        copies = []
        replace = sdk.os.replace
        def observed(old, new):
            copies.append(Path(new).relative_to(self.root).as_posix())
            return replace(old, new)
        with patch.object(sdk.os, "replace", side_effect=observed):
            sdk.initialize(self.root, "linux", "amd64", self.pins)
        self.assertEqual(copies, ["src/cmd/go.mod", "src/go.mod"])
        for path, data in self.originals.items():
            self.assertEqual(path.read_bytes(), data)
        for path in self.dirs:
            self.assertEqual(stat.S_IMODE(path.stat().st_mode), 0o555)
        for name in ["bin/go", "bin/gofmt", "pkg/tool/linux_amd64/compile", "lib/wasm/go_js_wasm_exec"]:
            self.assertEqual(stat.S_IMODE((self.root / name).stat().st_mode), 0o555)
        self.assertEqual(stat.S_IMODE((self.root / "lib/wasm/wasm_exec.js").stat().st_mode), 0o444)
        self.assertEqual((self.root / "src/go.mod").read_bytes(), b"module std\n")
        with patch.object(sdk.os, "replace", side_effect=AssertionError("idempotent initialization copied")):
            sdk.initialize(self.root, "linux", "amd64", self.pins)

    def test_bad_hash_and_wrong_coordinate_do_not_mutate(self):
        self.pins.write_text(self.pins.read_text().replace(hashlib.sha256(b"reviewed-go").hexdigest(), "0" * 64))
        with self.assertRaisesRegex(ValueError, "SHA-256"):
            sdk.initialize(self.root, "linux", "amd64", self.pins)
        with self.assertRaisesRegex(ValueError, "coordinate"):
            sdk.initialize(self.root, "linux", "arm64", self.pins)
        self.assertEqual(stat.S_IMODE((self.root / "bin/go").stat().st_mode), 0o444)
        self.assertFalse((self.root / "src/go.mod").exists())

    def test_symlink_rejected(self):
        self.root.chmod(0o755)
        (self.root / "escape").symlink_to(self.pins)
        self.root.chmod(0o555)
        with self.assertRaisesRegex(ValueError, "symlink"):
            sdk.initialize(self.root, "linux", "amd64", self.pins)
        self.assertEqual(stat.S_IMODE((self.root / "bin/go").stat().st_mode), 0o444)


if __name__ == "__main__":
    unittest.main()
