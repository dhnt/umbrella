# Manual candidate validation

Run the **Migrated workspace validation** workflow at the exact umbrella commit
under review. The default `all` selection runs every configured lane. A narrower
selection is useful for a relevant rerun, but is not a full validation result.
The checkout hydrates the recorded recursive gitlinks; no lane updates pins,
creates release tags or publishes binaries.

| Lane | Runner coverage | Existing contracts |
|---|---|---|
| `native` | Linux, macOS, Windows; workspace and standalone | Bashy product build, vet, native/portable unit tests and public E2E; Coreutils/Yoke CI contracts; Sh quick or Windows build; Outpost Unix headless and PTY tests or Windows build; Bashsharp, Bonsai, Gfy, Nadir and Ycode short tests. |
| `module-tests` | Linux; workspace and standalone | Agent-bench, Appstore, Filebrowser, Gotreesitter, Readline and Yamux root/v5 short unit suites. |
| `bashy-full` | Linux | Full `make test`, including SPA freshness, isolation, build-tag, scratch-image and startup gates; Node and pnpm provisioned. |
| `shell-full` | Linux and macOS | `make test-full`; Linux also runs the existing race/lifecycle gate and Bash 5.2 confirm tests. |
| `bash53` | Linux and macOS native with PTY; Windows measurement | Existing pinned Bash 5.3 corpus; Unix `make test-bash`; Windows locale provisioning, containment tests and existing fixture-count reporter. |
| `free-posix` | Linux with Docker | Existing contained Bash fixture gate and `scripts/posix-certdryrun.sh` aggregator, including its INFO/PENDING accounting. |
| `bashsharp` | Linux | Existing full `harness/run.sh`, with unchanged PASS/FAIL/PLANNED definitions and prerequisite checks. |

Each lane retains the umbrella SHA, recursive submodule pins, toolchain, platform,
dependency mode, raw command logs and exact exit codes. Built Bashy/shell artifact
SHA-256 values are recorded when those binaries exist. A failed command fails its
lane; independent commands continue to produce their own evidence. Job-level
cancellation or timeout is incomplete, regardless of any earlier passing command.

Standalone lanes set `GOWORK=off` so versioned dependency failures cannot hide
behind local workspace replacements. Workspace lanes exercise the candidate's
live sibling trees. The Windows Bash fixture reporter uses standalone mode
because its existing build command explicitly uses `-mod=mod`.

## Coverage boundaries and prerequisites

- Coreutils and Yoke retain their reviewed Unix no-regression ratchets. A green
  ratchet means baseline agreement, not that every recorded test passed. Keep
  the raw failures and baseline references when reporting results.
- Windows Sh full interpreter and Outpost shell/PTY behavior are not measured
  here; the native lane reports build coverage for those surfaces. Windows
  fixture counts are measurements, not an inferred Unix 86/86 result.
- Free-suite INFO and PENDING results are not passes. Licensed certification
  infrastructure and restricted reports are outside this public workflow.
- Bash# provisions exact public nanochat, mini-SWE-agent and OpenCode revisions,
  Bun 1.3.14, TypeScript from OpenCode's frozen lock, Python 3.12 and the
  checksum-pinned official Go source corpus. No provider credentials are used.
  Python dependencies lack an upstream lock at the fixture revision; their
  resolved versions are retained in `python-fixture-packages.txt`.
- Bash# requires a separately reviewed exact candidate. First dispatch
  `candidate-prepare`; inspect its immutable `bashsharp-candidate-linux` artifact,
  including `gbe-candidate.json`, `UNAPPROVED-candidate-row.tsv`, binary build
  metadata, SDK digest and `candidate-binaries.tar`. The draft row is never
  automatically added to the registry. Review the bytes, source revisions and
  SDK against the existing build-toolchain registry before committing approval
  in `bashsharp-tests/docs/go-by-example/candidates.tsv`.
  Then dispatch `all` or `bashsharp` with `candidate_run_id` naming that prepare
  run. The lane downloads and restores those exact executable bytes without
  rebuilding. Its product source revisions must still match the approved
  manifest; changing them requires another prepare/review cycle. Manifest paths
  are relative to the harness checkout and contain no runner-specific roots.
  Missing selection, unreviewed manifest, changed binaries or changed sources
  fail the gate. Preparation alone never establishes corpus coverage.
- `PLANNED` fixtures remain in the corpus denominator and are reported as
  planned; they are never converted to passes by this workflow.
- Native optional GPU/engine backends, hardware-specific integration and live
  third-party services require their own existing project gates. These jobs do
  not establish coverage of those environments or grant formal certification.

Local reproduction on a prepared test host uses the same lane wrapper:

```bash
export EVIDENCE_DIR="$(mktemp -d)"
export RUNNER_OS=Linux              # macOS or Windows on those hosts
export DEPENDENCY_MODE=workspace   # standalone selects GOWORK=off
bash script/validation.sh native
```

Keep evidence outside the checkout. Full builds and foreign conformance suites
belong on prepared test hosts, not the development machine. The wrapper requires
Python 3, Go 1.27.2 and the lane-specific tools used by each existing runner.
