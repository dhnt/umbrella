# Sprint 628 master execution plan — Chrome browser Bash# command and skill (`chrome`)

## Outcome

Any agent or operator can run a single Bash# command and skill (`bashy chrome` and `bashy chrome-open`) across macOS, Linux, and Windows that:
1. **Detects first**: checks whether Google Chrome (or Chromium on Linux arm64) is already installed on the host (`CHROME` override, standard OS application paths, and `PATH`). If installed, reports `"already installed"` with its path and version and exits `0` immediately (`done`).
2. **Installs when missing**: installs Google Chrome using the platform's standard non-interactive mechanism (`brew install --cask google-chrome` or `.dmg` fallback on macOS; `apt-get` / `dpkg` `.deb` on Linux `x86_64` or `chromium` on `aarch64`; `winget` or official MSI via a `~~~powershell` fence on Windows), then re-verifies detection.
3. **Opens URLs cross-platform**: replaces the macOS-only local `chrome-open` one-liner (`/usr/bin/open -a "Google Chrome"`) with cross-platform URL opening (`chrome open URL...` and `chrome-open URL...`) across macOS, Linux, and Windows.
4. **Registers at bootstrap**: registered via `bashy/examples/defaults/bashy-defaults.bsh` from the source pin alongside `chrome-browser` resource seeding.

## Architecture & Files

| File | Role |
|---|---|
| `bashy/examples/chrome/chrome.bsh` | Executable Bash# script (`#!/usr/bin/env -S bashy --bashsharp`) with `#bashy` metadata (`@name chrome`, `@os darwin linux windows`, `@effects read write exec net`) and an embedded `~~~skill` guide. |
| `bashy/examples/chrome/go.mod` | Standalone module (`module bashy/examples/chrome`) so `GOWORK=off go test ./examples/chrome/...` runs hermetically. |
| `bashy/examples/chrome/chrome_test.go` | Hermetic Go test suite covering `--skill`, `status`, `path`, `doctor`, idempotent `ensure`/`install` when Chrome is already detected (`CHROME` override and fake OS path), dry-run install commands per OS, and `open`. |
| `bashy/examples/defaults/bashy-defaults.bsh` | Adds `chrome` and `chrome-open` to `DEFAULT_COMMANDS` and seeds the `chrome-browser` resource (`kind: browser`, guard `bashy browser`). |
| `bashy/examples/defaults/bashy_defaults_test.go` | Updates default command count and assertions to include `chrome` and `chrome-open`. |

## Stories

| Story | Priority | Scope | Verification |
|---|---|---|---|
| **C1** `chrome.bsh` + `bashy-defaults.bsh` + unit tests | P0 | Implement `bashy/examples/chrome/chrome.bsh`, register `chrome` and `chrome-open` in `bashy-defaults.bsh`, and add unit tests in `bashy/examples/chrome/chrome_test.go` and `bashy/examples/defaults/bashy_defaults_test.go`. | `GOWORK=off go test ./examples/chrome/... ./examples/defaults/...` green on macOS. |
| **C2** Linux live verification on the Linux test host | P1 | Claim the Linux test host resource, run `chrome.bsh` (`status`, `doctor --json`, `ensure`, `path`, `--skill`) on Linux, and verify the detect-first and install/ready path end-to-end. | Live command outputs recorded in story evidence; host claim released. |
