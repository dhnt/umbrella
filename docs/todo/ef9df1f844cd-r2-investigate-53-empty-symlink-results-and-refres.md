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
