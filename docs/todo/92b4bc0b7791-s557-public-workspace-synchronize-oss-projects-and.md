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

Worker-reported snapshot of umbrella `bfe7b0a` and cached upstream refs.
The table is retained as reported inventory, not a fresh remote observation.
Independent review coverage and unverified claims are distinguished below.

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

### 2. Preserved Worktrees and Limits of Integration Evidence

The worker reported inspecting 18 worktrees without deleting, stashing or
resetting work. Its inventory is retained below as a reported snapshot; it is
not a cleanup authorization or an independently verified count of unique work.

| Reported category | Worktrees |
|---|---|
| HEAD reported as a canonical ancestor | Bashy: `s557-bashy-modernish-xtrace-fd`, `s557-windows-redir-probe`; Bonsai: `s557-bonsai-log-rotation`; Sh: `s557-sh-fc-pty`, `s557-sh-modernish188`, `s557-sh-nonfork190-baseline` |
| Non-ancestor HEAD reported with patch-equivalent commits upstream | Umbrella: `s557-umbrella-matrix-binding`, `s557-umbrella-modernish-trace`; Bashy: `s557-bashy-elfaudit-bounds`, `s557-bashy-modernish-trace`; Bonsai: `s557-bonsai-export`; Ycode: `s557-ycode-pty66`; Sh: `s557-sh-alias-performance`, `s557-sh-history183`, `s557-sh-modernish-control-alias`, `s557-sh-modernish-unexport`, `s557-sh-windows-redir` |
| Mixed patch-equivalence result, manual review outstanding | Sh: `s557-sh-gate-prereqs` |
| Additional untracked content reported | `s557-sh-fc-pty`: `docs/todo/79456e1ca444-s557-repair-interactive-fc-editor-pty-input-owners.md` |

Independent read-only review confirmed these specific command results against
canonical branches at review time:

- `git cherry main 71ce462` in umbrella returned
  `- 71ce46253007019b56b7d69482f59a784541cc7f`.
- `git cherry master 4b4920a1` in Sh returned `-` for `abd42856`,
  `d7d81669` and `4b4920a1`, and `+` for `35a3b8c8`.

A minus means Git found an equivalent patch upstream; it does not identify the
matching upstream commit or establish that the branch tip is an ancestor.
A plus means Git did not find an equivalent patch, not necessarily that the
feature is absent. The proposed decomposition of `35a3b8c8` has not been
established: manual source/evidence review remains required. Unsupported exact
counterpart SHAs from the earlier report are withdrawn. Other ancestry and
patch-equivalence rows above remain worker-reported, not independent findings.
Cleanliness, ignored/untracked content, current ancestry and lifecycle ownership
must be checked separately before any removal.

### 3. Module Boundaries and Verification Scopes

- **Root workspace (`go.work`)**: Independent source inspection at umbrella
  `bfe7b0a` confirms 25 `use` entries: 16 top-level modules and nine nested
  modules (`coreutils/third_party/goawk`, `yamux/v5`, `ycode/examples/genie`,
  `yoke/external/ollama/src`, `yoke/external/otel`, `yoke/external/podman/src`,
  `yoke/pkg/llmgw`, `yoke/pkg/oci`, `yoke/pkg/provider`). The worker reported
  `go work edit -fmt`; that command is not evidence of compilation or cycle checks.
- **Downloaded module cache integrity**: The worker reported exit 0 from
  `GOWORK=off go mod verify` in 16 top-level modules (agent-bench, appstore,
  bashsharp, bashy, bonsai, coreutils, filebrowser, gfy, gotreesitter, nadir,
  outpost, readline, sh, yamux, ycode, yoke). Raw per-command receipts were not
  located in the retained review artifact. This command checks downloaded cache
  integrity; it does not establish standalone compilation/resolution, clean-cache
  dependency completeness, absence of import cycles, or network-independent builds.
- **Shell syntax**: `bash -n script/*.sh` checks only the first expanded script,
  `bootstrap.sh`. The worker subsequently reported a per-file loop,
  `for f in script/*.sh; do bash -n "$f"; done`, passing five scripts:
  `bootstrap.sh`, `scrub-gate.sh`, `sync.sh`, `validation-oci.sh`, `validation.sh`.
  Raw per-file exit receipts were not located. The loop's final exit alone would
  not establish all five results unless intermediate failures were captured.
- **Scrub gate**: The worker reported exit 0 from `script/scrub-gate.sh --all`;
  raw execution receipts were not located. Independent source inspection confirms
  that its finite configured regexes inspect root-repository tracked regular text
  files, skip submodule directories and listed binary suffixes, and optionally
  include `.scrub-patterns.local`. Even a verified pass would not establish zero
  private content throughout submodules or the entire public tree.

No additional tests or gates were executed for this corrective documentation
review. The retained worker response is a self-report, not raw tool receipts.

### 4. Transferred Checklist Disposition (`17bccfc3f954`)

- `17bccfc3f954` (bashy #3037): Reconciled. The standalone candidate currently pins earlier validated producer revisions (`coreutils`, `ycode`, `yoke`, `sh`). Module pins legitimately exclude later documentation-only commits to maintain immutable candidate verification while concurrent shell repairs proceed. Alignment of `bashy/go.mod` to final producer revisions is held pending root's integration of the remaining shell runtime fixes.

### 5. Pass/Blocker Reconciliation Matrix

| Area | Status | Evidence / Limits / Notes |
|---|---|---|
| Canonical branches, heads and gitlinks | WORKER-REPORTED SNAPSHOT | Inventory above describes umbrella `bfe7b0a` and its cached upstream refs; no fresh remote observation is established by this report. |
| Candidate vs snapshot distinction | VERIFIED SOURCE COMPARISON | Independent review confirmed all seven changed submodule diffs from `cd91b04` to `bfe7b0a` contain only `docs/todo/` paths. This is not a statement about later HEADs. |
| Worktree preservation and integration | PARTIAL EVIDENCE | Specific `git cherry` results are recorded above. Other rows remain worker-reported; `35a3b8c8` manual review and all cleanup prerequisites remain outstanding. |
| Root workspace inventory | VERIFIED SOURCE COUNT | 25 `use` entries; no compilation, dependency-completeness or import-cycle verdict. |
| Downloaded cache integrity | WORKER-REPORTED PASS | Sixteen top-level modules; raw receipts not located. Standalone build/resolution is not established. |
| Root scrub gate | WORKER-REPORTED PASS | Finite configured patterns in root tracked text only; raw receipt not located. |
| Public script syntax | WORKER-REPORTED PASS | Five per-file checks reported; raw individual exits not located. |
| Final candidate producer pin bump (`17bccfc3f954`) | PENDING ROOT INTEGRATION | Final runtime fixes, candidate selection and relevant producer pins/gates remain manager-owned. |
