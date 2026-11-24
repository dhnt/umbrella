# Sprint 675: review and master execution plan

Sprint UUID: `9b07aedb-77af-52d5-8af3-8035a213774c`.
Reviewed 2026-11-24 with the operator. State at review: backlog, 0/7 stories
closed, conductor unclaimed, no weave or claim on it. This document records
the review and the execution order; the scope and rules stay in the spec,
[plan-posix-certification-after-separation.md](plan-posix-certification-after-separation.md).
The sprint card and its stories remain authoritative.

Nothing has started. Starting needs the operator decisions listed at the end.

## What the sprint is

Investigation and preparation only: explain each of the 67 retained non-pass
results of the tagged S575 baseline and prepare the evidence, manual-review
and authority packets for POSIX certification. The card forbids production
edits, a new full run, external correspondence or submission, fees,
certification claims and an RC38 tag or release.

| Family | Count | Story |
| --- | ---: | --- |
| `more` FAIL (TPs 130, 132, 133, 134) | 4 | R4 `c02bdd0e36cc` |
| Empty-target symlink setup UNRESOLVED | 53 | R2 `ef9df1f844cd` |
| `man` command-count precondition UNRESOLVED | 1 | R3 `52d169ab8c3b` |
| INSPECT (`stty` 7, `df` 1, `locale` 1) | 9 | R5 `bf5e89e38c78` |

R1 `4088102f4f39` (P0) reconciles all 67 identities first. R6 `60e864ce9f7a`
is conditional on a proven defect. R7 `2f848bba27c7` consolidates.

## Where the inputs come from

- **Sprint 575 (done) is the evidence source.** Its story `ca76921cf9e5` ran
  the unchanged full Profile D measurement on 2026-11-19 and was accepted as
  a measurement and retention close only: not a certification pass, not an
  authority ruling, not a manual disposition. It published the marker
  `posix-baseline/s575-2026-11-19`. Public record:
  [S575 engineering baseline](../bashy/docs/s575-posix-engineering-baseline.md).
- **Sprint 571 is where the seven story identities originated** (2026-11-05,
  against the older S561 candidate). They moved to 675 on 2026-11-19 with the
  same IDs. Sprint 571 keeps only its documentation story R8; it is separate
  housekeeping and not part of this plan.
- **Existing packets are reused, not rewritten:** the S355 authority packets
  (symlink-53, `more`, the `man` question), the S377 operator resolution of
  the nine INSPECT items, and the S371/S385 external-decision ownership.
  They live in the private harness kit.

## Review findings

1. **Sealed evidence archive: located and verified.** The public records give
   only its SHA256 (`63cd77b9…05fe1`) and "the maintainer's private evidence
   store". On 2026-11-24 the archive was found in that store on the
   maintainer workstation and its full SHA256 matched; it lists 196 regular
   files, as the baseline record states. Its exact location, receipts and the
   companion 493-TP shell archive are now indexed in the private harness kit
   (`docs/S575-FULL-D-EVIDENCE-INDEX-20261119.md` there), which had no record
   of them before. On that workstation an agent reads the location without
   probing the system, from any directory or checkout:
   `bashy kb context --for "S575 evidence archive location"` reads the
   repository and host knowledge bases together and returns the host page
   `s575-posix-evidence-archive-location`. (`bashy kb search` reads one
   store at a time and needs `--user` inside a repository; making it
   host-wide by default is filed as a todo.) Restricted content never
   enters this repository.
2. **Private harness checkout was behind.** The measured harness commit
   `6966bc6` is on the kit's origin default branch; the workstation's local
   checkout was 12 commits behind and was fast-forwarded during this review.
   Read the harness at `6966bc6`.
3. **Investigate the frozen source, not heads.** The marker resolves on the
   Bash repository (`7855c2f0`) and Coreutils (`c6569352`). Coreutils is five
   commits past the marker (by subject: sibling pins, todo records and the
   Go 1.27.4 toolchain selection); the umbrella is several hundred commits
   past its approval snapshot. The "current heads" rule applies to this
   sprint's own documentation commits; every finding cites the tagged source.
4. **The toolchain moved.** The baseline was built with Go 1.27.2; the
   workspace now selects go1.27.4. Any R6 repair proposal names the artifact
   identity its verification would produce and does not reuse the 1.27.2
   artifact evidence for changed inputs.
5. **The shared engine is still mixed.** Sprint 575 deferred the engine
   split. Until it lands, a shared engine or CLI change needs both the
   Bash/POSIX and the Bash# regression checks, so an R6 proposal touching the
   shell includes both in its verification plan.
6. **No licensed venue exists.** The disposable test venue was retired after
   retention. R2-R5 are journal and source analysis; rerunning licensed tests
   can only be proposed, with a concrete request, never assumed.
7. **No reviewer is named.** R5 requires a qualified independent review and
   R7 an independently reviewed dossier. See the open decisions.
8. **`more` is probably an optional target.** The Sprint 341 base scope lists
   14 optional targets that do not gate, `more` among them. If the kit's
   scope record confirms it for this run, R4 is mainly a scope recommendation.
   This was not re-checked during the review; R4 must check it at the source
   and keep the four raw FAIL results either way.

## Execution order

| Phase | Story | Work | Owner | Gate to proceed |
| --- | --- | --- | --- | --- |
| 0 | - | Take the sprint; re-verify the archive and artifact-manifest checksums; read-only worktrees of Bash and Coreutils at the marker; harness at `6966bc6` | conductor | Checksums match the baseline record |
| 1 | R1 | 67-row ledger from the journals; compare identities and diagnostics by name with S561; map each row to its existing packet and decision owner | conductor | Operator reviews the ledger and ownership matrix |
| 2 | R2 | Analyse the 53 symlink results; refresh the existing packet | worker | Cause or exact uncertainty recorded per identity |
| 2 | R3 | Trace the `man:4` control flow (109 available names against a greater-than-109 test); write the authority question | conductor | Same |
| 2 | R4 | Analyse the four `more` results from the retained locale diagnostics; scope recommendation | worker | Same |
| 2 | R5 | Nine INSPECT review packets, checking that each S377 decision applies to this journal | worker | Same, plus independent review |
| 3 | R6 | Repair proposals only where Phase 2 proves a defect; otherwise recorded no-repair reasoning | finder | Operator approves any implementation separately |
| 4 | R7 | Readiness matrix; check the current program, profile, kit terms and submission requirements against official sources; blockers, owners, handoff | conductor | Independent review, then end the sprint |

The four Phase 2 stories are independent and run in parallel. Workers are
assigned across vendors, and the reviewer of a packet is from a different
vendor than its author.

## Working rules for this sprint

- **Output placement.** Journal excerpts, the per-TP ledger, review packets
  and prepared correspondence go to the private harness kit. Public
  repositories receive counts, identities, dispositions and this plan.
- **Verdicts.** Raw results are never edited. A disposition is recorded
  beside the raw verdict, never in place of it. A prepared packet is not a
  ruling; a historical manual PASS is not carried over without evidence from
  this journal and a reviewer.
- **Scope.** The declared base stays 102 providers: 92 Go utilities and 10
  shell commands, zero external utility providers. No utility is added and
  no prerequisite weakened to satisfy a count.
- **Testing.** The sprint runs no suite. There is nothing to build.
- **Stop and report** when: a checksum does not verify; the 67 identities or
  their diagnostics differ from S561; or a finding needs code, a licensed
  run or an external send.

## Open operator decisions

1. **Go:** take the sprint and run Phase 0.
2. **Reviewer:** proposed - a different-vendor agent reviews R5 and R7, and
   the operator remains the decision owner for the nine INSPECT items, as in
   S377.
3. **Probes:** whether workers may run their own small probes against the
   frozen binaries on the gate host (for example empty-target symlink
   behaviour). These are not licensed tests. Without them R2 and R4 rest on
   journal and source reading alone.

Resolved during the review: the archive location (finding 1).
