---
id: 92b4bc0b7791
kind: chore
title: 'S557 public workspace: synchronize OSS projects and provide independent development and test entrypoints'
seq: 4
status: assigned
priority: p1
created: 2026-11-01T09:17:34.646235Z
weave: 2
assignee: agy-gemini3.8-flash
sprint: 557
sprint_id: f5ccf563-f5d1-5b94-8be4-9388e51ef86d
sprint_title: 'Bashy v1.0.0 preparation: split private/public development and retire qiangli/dhnt'
---

Prepare the public workspace for the official Bashy v1.0.0 release: synchronize public submodule heads, hydrate required public modules, maintain version-pinned standalone builds and an optional sibling workspace, update bootstrap/sync/CI and developer documentation. Preserve unique work. Public builds must not require private sources, credentials or licensed conformance fixtures. Record reproducible public verification commands and sanitized evidence. Keep all private coordination in the private migration record.

## Consolidated acceptance ownership — 2026-11-02

Operator-directed triage: implementation mistakes, review corrections and failed tests belong to this existing deliverable, not new stories. Superseded child records retain their original scope and evidence. Their decision closure means responsibility transferred here, NOT fixed, passed, waived or feature retirement. Keep this parent open until its acceptance is verified. New stories require genuinely independent scope.

Release constraint: RC tags only, using the existing format. Official v1.0.0 requires completed official POSIX certification and separate explicit operator approval even if every test passes. Formal certification is deferred; the migration still requires its shell-only conformance gate.

Remaining acceptance: canonical public branches and published producer revisions, independent clean-checkout/standalone builds, synchronized gitlinks and module pins, no private dependency, and preservation of unique work. Candidate pin updates and any corrections stay here. Validation may retain an immutable candidate while later documentation commits advance a branch; reconcile final gitlinks before closure.

### Transferred implementation and verification checklist

Every row retains its original acceptance and evidence in the named source record; verify disposition within this parent before closure. These rows are tasks, not additional stories.

- [ ] `17bccfc3f954` (bashy #3037): S557 align standalone release candidate with validated producer revisions. Reconcile existing evidence and any remaining verification.

## Active bounded worker assignment — 2026-11-02

Immediate bounded assignment: verify remaining publicworkspace readiness against currentcanonical roots and reconcile precise blockers. Read parentandcurrenttriage; rootisrunningruntimefixworkseparately. Readonly canonicalinventory: branch/HEAD/upstream/dirty/gitlink/moduleboundary for publicumbrella+submodules; distinguish documentation-onlypinchanges fromruntimecandidatecd91b04. Inspect remainingrun/worktreeuniquecommits without removingorresettinganything. Source/candidate modulepins maylegitimately exclude laterdocs; no blindmassgo get. Identify concrete brokenpaths/private dependencies relevantmigration. Use managedisolatedworkspace for any small neededscript/docfix, preserve originalassertions/semantics. Do not modifycanonical/frozen dhnt, inspectlicensedtrees, createcloudresources, runfullbuildsuiteorcontainers, orpush/merge. No newstories. Within5minutes send inventorysummaryandone nextaction; within twenty minutes deliver concise exactpass/blocker matrixandscopedcommitifnecessary. Useexisting557/#4/92b4bc0b7791 actualAgent. Rootowns allcleanupmutations andfinalacceptance.

All agents: subscription-backed route only; no metered/API fallback. Do not create stories for corrections; append evidence to this parent. Manager checks concrete progress every five minutes, steers and reassigns stalled work.

## Canonical Public Workspace Inventory and Pass/Blocker Matrix — 2026-11-02

### 1. Canonical Inventory Summary (18 Public Submodules)

| Submodule | Canonical Branch | HEAD SHA | Umbrella HEAD Gitlink | Matches Gitlink | Ahead/Behind Upstream | Dirty | Status / cd91b04 Pin Delta |
|---|---|---|---|---|---|---|---|
| agent-bench | main | `f5c2f7b7` | `f5c2f7b7` | Yes | 0 / 0 | Clean | Match candidate |
| appstore | main | `c64e8464` | `c64e8464` | Yes | 0 / 0 | Clean | Match candidate |
| bashsharp | main | `97efb5cc` | `97efb5cc` | Yes | 0 / 0 | Clean | Match candidate |
| bashsharp-tests | main | `acb7a86d` | `acb7a86d` | Yes | 0 / 0 | Clean | Docs-only advance from `eeb1bbfd` |
| bashsharp-tour | main | `00c6a1f3` | `00c6a1f3` | Yes | 0 / 0 | Clean | Match candidate |
| bashy | main | `b353e2df` | `b353e2df` | Yes | 0 / 0 | Clean | Docs-only advance from `7e206d9e` |
| bonsai | main | `6784010b` | `6784010b` | Yes | 0 / 0 | Clean | Docs-only advance from `98dcbb2e` |
| coreutils | main | `2ff8ab0f` | `2ff8ab0f` | Yes | 0 / 0 | Clean | Match candidate |
| filebrowser | master | `d1d2feab` | `d1d2feab` | Yes | 0 / 0 | Clean | Match candidate |
| gfy | main | `30d38f08` | `30d38f08` | Yes | 0 / 0 | Clean | Match candidate |
| gotreesitter | main | `210e9a92` | `210e9a92` | Yes | 0 / 0 | Clean | Match candidate |
| nadir | main | `4af32a9e` | `4af32a9e` | Yes | 0 / 0 | Clean | Match candidate |
| outpost | main | `f39c5f09` | `f39c5f09` | Yes | 0 / 0 | Clean | Docs-only advance from `581a2a6f` |
| readline | master | `df59d4e2` | `df59d4e2` | Yes | 0 / 0 | Clean | Match candidate |
| sh | master | `d816fd72` | `d816fd72` | Yes | 0 / 0 | Clean | Docs-only advance from `81f16692` |
| yamux | main | `355202aa` | `355202aa` | Yes | 0 / 0 | Clean | Match candidate |
| ycode | main | `45e39aae` | `45e39aae` | Yes | 0 / 0 | Clean | Docs-only advance from `23d0ff4f` |
| yoke | main | `5602c7a0` | `5602c7a0` | Yes | 0 / 0 | Clean | Docs-only advance from `556b27f0` |

- **Candidate vs HEAD distinction**: Exactly 7 submodules advanced beyond runtime candidate `cd91b04`. Every diff between `cd91b04` and `bfe7b0a` across all 7 submodules consists strictly of story and acceptance documentation records under `docs/todo/` (plus sh commit `5948a83f` recording hosted fc terminal regression check acceptance). Zero runtime, parser, evaluator, or test code changed.
- **Gitlink modes**: All 18 submodule gitlinks in the umbrella index verified as mode `160000`.

### 2. Preservation of Unique Worktrees and Work

Audited all 18 active worktrees across umbrella and submodules. Zero work was stashed, deleted, or reset.
Ancestry (`git merge-base --is-ancestor`) and patch equivalence (`git cherry <canonical-branch> <sha>`) were evaluated:
- **Direct canonical ancestors** (ahead count 0): 6 worktrees:
  - `bashy`: `s557-bashy-modernish-xtrace-fd` (`a688be7d`), `s557-windows-redir-probe` (`7ba1e36a`)
  - `bonsai`: `s557-bonsai-log-rotation` (`9137fd3`)
  - `sh`: `s557-sh-fc-pty` (`c0e71e66`), `s557-sh-modernish188` (`a228a27c`), `s557-sh-nonfork190-baseline` (`6663c93a`)
- **Non-ancestors verified patch-equivalent upstream** (`git cherry` returns `-`, indicating equivalent patch already merged into canonical branch under a different commit SHA): 11 worktrees:
  - `umbrella`: `s557-umbrella-matrix-binding` (`71ce462` -> `-`, equivalent to `303d43cf` in `main`), `s557-umbrella-modernish-trace` (`15b442d` -> `-`, equivalent to `4dfc3bdb` in `main`)
  - `bashy`: `s557-bashy-elfaudit-bounds` (`51dcb43a` -> `-`, equivalent to `bb622f60` in `main`), `s557-bashy-modernish-trace` (`bf2ca6a7` -> `- 5c796197`, `- bf2ca6a7`, equivalent to `bb4f3b7b` and `5bdfcbe8` in `main`)
  - `bonsai`: `s557-bonsai-export` (`42a2007` -> `-`, equivalent to `6784010b` in `main`)
  - `ycode`: `s557-ycode-pty66` (`ed3dd64` -> `-`, equivalent to `45e39aae` in `main`)
  - `sh`: `s557-sh-alias-performance` (`8421dc93` -> `-`, equivalent to `7c44e9ce`), `s557-sh-history183` (`b3b72ebb` -> `-`, equivalent to `681d4da7`), `s557-sh-modernish-control-alias` (`5ff9db75` -> `-`, equivalent to `da495901`), `s557-sh-modernish-unexport` (`ab96560e` -> `-`, equivalent to `0a430c45`), `s557-sh-windows-redir` (`665c4290` -> `-`, equivalent to `fc80ba5d`)
- **Non-ancestor with split/decomposed patch**: 1 worktree:
  - `sh`: `s557-sh-gate-prereqs` (`4b4920a1`): 3 of 4 commits return `-` (`abd42856`, `d7d81669`, `4b4920a1`); commit `35a3b8c8` returns `+` because its authored test diff was decomposed across `978152ca` and `da495901` when integrated upstream.
- **Untracked work preserved**: 1 worktree:
  - `sh`: `s557-sh-fc-pty` retains untracked story record `docs/todo/79456e1ca444-s557-repair-interactive-fc-editor-pty-input-owners.md`.

### 3. Module Boundaries, Standalone Dependencies, and Verification Scopes

- **Root workspace (`go.work`)**: Verified format (`go work edit -fmt`), exactly 25 `use` directives for live sibling modules (16 top-level public submodules and 9 nested modules/packages: `coreutils/third_party/goawk`, `yamux/v5`, `ycode/examples/genie`, `yoke/external/ollama/src`, `yoke/external/otel`, `yoke/external/podman/src`, `yoke/pkg/llmgw`, `yoke/pkg/oci`, `yoke/pkg/provider`), with explicit public fork replacements.
- **Downloaded module cache verification (`GOWORK=off go mod verify`)**: Tested and exited 0 across all 16 Go modules (agent-bench, appstore, bashsharp, bashy, bonsai, coreutils, filebrowser, gfy, gotreesitter, nadir, outpost, readline, sh, yamux, ycode, yoke).
  - *Evidence and exact limits*: `go mod verify` verifies only the cryptographic hash integrity of previously downloaded module cache entries against each module's `go.sum`. It does NOT test or prove standalone package compilation/resolution, absence of missing dependencies in clean environments, absence of import cycles, or network independence during fresh builds.
- **Verification scripts syntax**:
  - *Command limitation*: Running `bash -n script/*.sh` checks only the first script (`script/bootstrap.sh`) due to shell parameter handling where subsequent names are treated as arguments to the script.
  - *Bounded per-file check*: A bounded per-file loop `for f in script/*.sh; do bash -n "$f"; done` was executed across all 5 scripts (`bootstrap.sh`, `scrub-gate.sh`, `sync.sh`, `validation-oci.sh`, `validation.sh`); all 5 passed syntax inspection.
- **Scrub gate audit (`script/scrub-gate.sh --all`)**: Passed clean (exit 0).
  - *Evidence and exact limits*: `script/scrub-gate.sh --all` only inspects tracked regular text files in the root umbrella repository against finite built-in regexes (tokens/credentials, non-documentation IPv4 addresses, `/Users/`, `/home/`) and optional `.scrub-patterns.local`. It explicitly skips gitlink mode `160000` entries (`[ -f "$f" ] || continue`) and binaries (`*.png|*.pdf|*.zip|...`), and does not inspect the internal contents of submodule repositories. Therefore, passing this gate confirms no staged/tracked root text matches the configured scrub regexes, but is not a claim that the entire public tree has zero private paths, repos, or fixtures beyond those pattern checks.

### 4. Transferred Checklist Disposition (`17bccfc3f954`)

- `17bccfc3f954` (bashy #3037): Reconciled. The standalone candidate currently pins earlier validated producer revisions (`coreutils`, `ycode`, `yoke`, `sh`). Module pins legitimately exclude later documentation-only commits to maintain immutable candidate verification while concurrent shell repairs proceed. Alignment of `bashy/go.mod` to final producer revisions is held pending root's integration of the remaining shell runtime fixes.

### 5. Pass/Blocker Reconciliation Matrix

| Area | Status | Evidence / Limits / Notes |
|---|---|---|
| Canonical branches & heads | PASS | All 18 submodules checked out to canonical `main` or `master`, synchronized with upstream (0 ahead / 0 behind). |
| Gitlink synchronization | PASS | All 18 gitlinks match submodule HEADs exactly; all mode `160000`. |
| Candidate vs HEAD distinction | PASS | 7 submodules advanced beyond candidate `cd91b04`; 100% of diffs are documentation/todo records (`docs/todo/`). |
| Worktree preservation & ancestry | PASS | All 18 worktrees inspected; 6 are direct ancestors of canonical branches, 11 have non-ancestor commits verified patch-equivalent upstream (`git cherry` returns `-`), 1 has a decomposed patch (`s557-sh-gate-prereqs`), and 1 has an untracked story record (`s557-sh-fc-pty`). Zero work deleted, reset, or stashed. |
| Module boundaries & `go.work` | PASS | Valid `go.work` with exactly 25 `use` directives (16 top-level + 9 nested modules/packages) and public fork replacements. |
| Downloaded cache integrity | PASS | All 16 Go modules verified downloaded module-cache hash integrity via `GOWORK=off go mod verify`. Scope limited to cache hash verification (no claim of standalone build, offline dependency completeness, or import cycle check). |
| Public scrub gate | PASS | `script/scrub-gate.sh --all` passed with 0 regex hits. Scope limited to tracked text files at umbrella root; skips submodule gitlinks and binaries. |
| Public scripts syntax | PASS | All 5 scripts verified clean via bounded per-file loop `for f in script/*.sh; do bash -n "$f"; done`. Single-file limitation of `bash -n script/*.sh` documented. |
| Final candidate producer pin bump (`17bccfc3f954`) | BLOCKED (pending runtime fix completion) | Blocked on root completing concurrent shell runtime repairs before cutting final candidate and re-pinning producer revisions in `bashy/go.mod`. |
