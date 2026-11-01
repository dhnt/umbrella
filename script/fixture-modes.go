// Copyright (c) 2026 qiangli
// See LICENSE for licensing information.

// fixture-modes records verified archive modes using the shell's Windows ACL
// contract. The provisioner supplies only regular files from a verified archive.
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"

	"mvdan.cc/sh/v3/winmode"
)

func main() {
	if err := apply(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func apply() error {
	if len(os.Args) != 2 || !winmode.Supported {
		return fmt.Errorf("fixture-modes requires Windows and one fixture directory")
	}
	var modes map[string]uint32
	if err := json.NewDecoder(os.Stdin).Decode(&modes); err != nil {
		return err
	}
	if len(modes) == 0 {
		return fmt.Errorf("empty fixture mode manifest")
	}
	for relative, mode := range modes {
		if !filepath.IsLocal(relative) || mode > 0777 {
			return fmt.Errorf("invalid fixture mode entry %q", relative)
		}
		path := filepath.Join(os.Args[1], relative)
		info, err := os.Lstat(path)
		if err != nil {
			return err
		}
		if !info.Mode().IsRegular() {
			return fmt.Errorf("fixture is not a regular file: %s", relative)
		}
		if err := winmode.Set(path, os.FileMode(mode)); err != nil {
			return fmt.Errorf("record mode %s: %w", relative, err)
		}
		if got, ok := winmode.Get(path); !ok || got.Perm() != os.FileMode(mode) {
			return fmt.Errorf("fixture mode readback mismatch: %s", relative)
		}
	}
	return nil
}
