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

Audited temporary and sibling worktrees; zero work was deleted, stashed, or reset.
- `umbrella` worktrees:
  - `s557-umbrella-matrix-binding`: commit `71ce462` (Bashsharp matrix candidate binding test hook in validation script).
  - `s557-umbrella-modernish-trace`: commit `15b442d` (Modernish diagnostic trace option).
- `bashy` worktrees:
  - `s557-elfaudit-bounds`: commit `51dcb43a` (signal artifact build gate isolation).
  - `s557-bashy-modernish-trace`: commits `bf2ca6a7`, `5c796197` (Modernish diagnostic traces).
  - `s557-bashy-modernish-xtrace-fd` & `s557-windows-redir-probe`: clean, fully integrated ancestors of main.
- `bonsai` worktrees:
  - `s557-bonsai-export`: commit `42a2007` (serialize RDF records during export).
  - `s557-bonsai-log-rotation`: clean, fully integrated ancestor of main.
- `sh` worktrees:
  - `s557-alias-performance`: commit `8421dc93` (alias ancestry scan bypass).
  - `s557-sh-gate-prereqs`: commits `4b4920a1`, `35a3b8c8`, `d7d81669`, `abd42856` (toolchain and reference test prerequisites).
  - `s557-sh-history183`: commit `b3b72ebb` (history reader suppression scoping).
  - `s557-sh-modernish-control-alias`: commit `5ff9db75` (compound alias parse in sourced input).
  - `s557-sh-modernish-unexport`: commit `ab96560e` (reject invalid command-form declaration probes).
  - `s557-sh-windows-redir`: commit `665c4290` (command substitution redirect capture isolation).
  - `s557-sh-fc-pty`: untracked story record `docs/todo/79456e1ca444-s557-repair-interactive-fc-editor-pty-input-owners.md` retained.
  - `s557-sh-modernish188` & `s557-sh-nonfork190-baseline`: clean, fully integrated ancestors of master.

### 3. Module Boundaries, Standalone Dependencies, and Scrub Gate

- **Root workspace (`go.work`)**: Clean format (`go work edit -fmt`), 24 `use` directives for live sibling modules, explicit fork replacements.
- **Standalone module verification (`GOWORK=off go mod verify`)**: Tested and verified clean across all 16 Go modules (appstore, bashsharp, bashy, bonsai, coreutils, filebrowser, gfy, nadir, outpost, readline, sh, ycode, yoke, agent-bench, gotreesitter, yamux). All modules resolve with zero network access and zero missing dependencies.
- **Private source boundaries**: No private repositories, internal URLs, or host-specific paths exist in the public workspace.
- **Verification scripts**: `bash -n script/*.sh` passed; `script/scrub-gate.sh --all` passed clean with zero violations.

### 4. Transferred Checklist Disposition (`17bccfc3f954`)

- `17bccfc3f954` (bashy #3037): Reconciled. The standalone candidate currently pins earlier validated producer revisions (`coreutils`, `ycode`, `yoke`, `sh`). Module pins legitimately exclude later documentation-only commits to maintain immutable candidate verification while concurrent shell repairs proceed. Alignment of `bashy/go.mod` to final producer revisions is held pending root's integration of the remaining shell runtime fixes.

### 5. Pass/Blocker Reconciliation Matrix

| Area | Status | Evidence / Notes |
|---|---|---|
| Canonical branches & heads | PASS | All 18 submodules checked out to `main` or `master`, synchronized with upstream (0 ahead / 0 behind). |
| Gitlink synchronization | PASS | All 18 gitlinks match submodule HEADs exactly; all mode `160000`. |
| Candidate vs HEAD distinction | PASS | 7 submodules advanced beyond candidate `cd91b04`; 100% of diffs are docs/todo/triage files. |
| Unique work preservation | PASS | All 17 worktrees inspected; 15 unique commits and 1 untracked record preserved without alteration. |
| Module boundaries & `go.work` | PASS | Valid `go.work`, correct fork mappings, no cycles or invalid directives. |
| Standalone `GOWORK=off` resolution | PASS | All 16 Go modules verified clean via `GOWORK=off go mod verify`. |
| Private dependency isolation | PASS | Zero private repository or private host dependencies in public tree. |
| Public CI & gates readiness | PASS | Shell scripts validate syntax (`bash -n`); public scrub gate passes on all tracked files. |
| Final candidate producer pin bump (`17bccfc3f954`) | BLOCKED (pending runtime fix completion) | Blocked on root completing concurrent shell runtime repairs before cutting final candidate and re-pinning. |
