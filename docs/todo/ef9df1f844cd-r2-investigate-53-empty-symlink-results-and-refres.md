---
id: ef9df1f844cd
kind: question
title: R2 Investigate 53 empty-symlink results and refresh the authority packet
seq: 14
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:27.709517Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Depends on R1. Inspect the original empty-target symlink setup diagnostics and relevant frozen implementation/venue behavior for all53 S575 results. Reuse the existing S355 symlink-53 packet and inherited case records. Determine whether prior rulings exist and apply to this exact run; distinguish established cause from unanswered semantics/configuration questions. Prepare the exact updated evidence, recipient and questions for later authorized transmission. Acceptance: reviewed causal analysis or precise uncertainty for all53, applicability mapping and ready-to-review packet. No automatic PASS, changed assertions, provider fallback or sent correspondence.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.

## Worker rules

Read `bashy sprint show 675` (directives D1-D12), `docs/sprint-675-master-execution-plan.md`, `docs/plan-posix-certification-after-separation.md`, `bashy/docs/s575-posix-engineering-baseline.md`, and the private-kit R1 ledger (`docs/S675-R1-RESIDUAL-67-LEDGER.md` and `.tsv`). Work on current default-branch heads; cite tested commits (`posix-baseline/s575-2026-11-19`: Bash `7855c2f0`, Coreutils `c6569352`, harness `6966bc6`) beside current heads (`5c52281f`, `e0184192`, `103c5d5`) when referencing source lines.

Locate the private evidence store, extracted S575 archive, S561 retained journals, and private harness kit via `bashy kb context --for "S575 evidence archive location"`, read `docs/S575-FULL-D-EVIDENCE-INDEX-20261119.md`, and re-verify the sealed archive SHA256 (`63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1`) and `sealed-build-manifest.txt` SHA256 (`6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138`) before use.

Deliverables and isolation:
1. Keep the shared private harness kit checkout clean: create an isolated `git worktree` of the private harness kit on branch `s675-r2` inside the private evidence store (never inside `umbrella`), write `docs/S675-R2-SYMLINK-53-AUTHORITY-PACKET.md`, and commit on `s675-r2` without pushing `main`.
2. Inspect all 53 S575 empty-target symlink setup `UNRESOLVED` (TET code 2) identities across their 55 IC occurrences (`test:84` and `leftbrack:84` each occur in two ICs), Coreutils `cmds/ln` source, and Linux `symlink("", ...)` `ENOENT` venue behavior.
3. Reuse and cross-check `docs/S355-D-SYMLINK-53-AUTHORITY-PACKET-20261002.md`, `docs/S377-SYMLINK-VENDOR-SOURCE-COMPARISON-20261006.tsv`, `docs/SPRINT-341-BASE-SCOPE.md`, and Sprint 385 external-decision records on this workstation. Verify that only an automated acknowledgment exists so far on the pending VSC technical inquiry (no granted ruling yet), distinguish the 52 base-set class-A identities from optional-but-executed `localedef:52` (class C, `POSIX2_LOCALEDEF=200809`), record established cause vs unanswered authority/specification questions for all 53, and prepare the refreshed unsent authority packet with exact S575 provenance, recipient, questions, and 53-identity appendix. Do not copy raw suite source; preserve raw `UNRESOLVED` codes.
4. In your `umbrella` weave workspace, append a scrubbed `## S675 R2 Summary` section to this story file with counts, the 53 identities, causal/applicability summary, external-blocker status (prepared packet / pending VSC ruling, not PASS), and the private-kit `s675-r2` commit SHA. Zero journal excerpts, correspondence text, credentials, hostnames, OS logins, emails, or home-directory paths (`script/scrub-gate.sh` is fail-closed; use host roles only).
5. Investigation only: no production code edits, no builds/suites/VMs/containers on the dev box, no licensed runs, no external correspondence. Commit in both repositories with `BASHY_AGENT` set to your assigned agent identity and trailers `Sprint: #675`, `Story: #14`, `Story-ID: ef9df1f844cd`, `Agent: <assigned-agent>`. Submit via `bashy sprint submit 675 ef9df1f844cd -m "<summary, umbrella SHA, private kit s675-r2 SHA>"`.

## S675 R2 Summary

Reviewed all 53 S575 empty-target symlink setup results against the sealed
S575 journals, the frozen `cmds/ln` implementation, and Linux venue behavior.
Counts: 53/53 identities confirmed raw `UNRESOLVED` (TET code 2) with the
identical empty-target setup diagnostic, across 52 journals (one journal
carries both `test:84` IC 1 and `leftbrack:84` IC 5; two further same-TP
ICs report `NOTINUSE` in the PASS group). S561 parity for these 53 rows is
exact: same identities, same raw code 2, byte-identical diagnostics. Sealed
archive and build-manifest checksums re-verified before use.

Identities (all raw `UNRESOLVED`, code 2; 52 class A base-set, 1 class C):
`awk:543`, `bc_03:48`, `cat:25`, `cd:41`, `chgrp:53`, `chmod:57`, `chown:56`,
`cksum_03:15`, `cmp:26`, `comm:32`, `cp:97`, `cut:43`, `dd:61`, `df:30`,
`diff:64`, `du:43`, `ed_14:47`, `env:27`, `file:64`, `find:142`, `fold:46`,
`grep:139`, `head:41`, `iconv:28`, `join:47`, `leftbrack:84`, `ln:59`,
`localedef:52` (class C, optional-but-executed), `ls:107`, `m4:101`,
`mkdir:60`, `mkfifo:48`, `mv:87`, `od:64`, `paste:43`, `pax:242`, `pr:56`,
`pwd:17`, `rm:56`, `rmdir:30`, `sed:272`, `sh_03:163`, `sort:86`,
`split:42`, `tail:48`, `test:84`, `touch:63`, `tsort:20`, `uniq:58`,
`uudecode:34`, `uuencode:25`, `wc:32`, `xargs:44`.

Causal summary (established): every result stops in suite setup before the
utility assertion because the empty-target link cannot be created on the
Linux venue; the Go `ln` passes the operand straight to the kernel
(`cmds/ln` identical at tested `c6569352` and head `e0184192`), so this is
shared platform behavior, not a product delta; suite origin of the empty
target confirmed by the inherited vendor comparison; no documented
configuration, procedure, option predicate, or supported correction
resolves any of the 53 (documentation-first investigation stands,
uncontradicted by S575). Applicability: 52 class-A base-set purposes
provisionally applicable subject to configured scenario and per-TP
predicates; `localedef:52` stays in the resolution queue pending explicit
authority treatment.

External-blocker status (not PASS): prior rulings checked — none granted.
The operator-sent technical inquiry has an automated acknowledgment only
(Sprint 385 records; no substantive response, no approved
version-applicable Problem Report). Unanswered authority questions recorded:
host-capability vs fixture-deficiency determination, existing-PR
identification, per-identity official-report treatment including
`localedef:52`, and replay scope. No automatic PASS, no changed
assertions, no provider fallback, no sent correspondence. Refreshed unsent
packet with S575 provenance, recipient, Q1a-Q1d, and 53-identity appendix
prepared for operator review in the private kit:
`docs/S675-R2-SYMLINK-53-AUTHORITY-PACKET.md` on branch `s675-r2` at commit
`662e709`. Replay gate: no affected set replayed without a sanctioned
disposition. No code, build, suite, VM, licensed run, or external send was
performed in this story.
