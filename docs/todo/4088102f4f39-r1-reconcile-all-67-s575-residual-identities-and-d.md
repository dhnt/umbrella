---
id: 4088102f4f39
kind: requirement
title: R1 Reconcile all 67 S575 residual identities and decision ownership
seq: 13
status: todo
priority: p0
labels:
    - posix-cert
created: 2026-11-05T04:19:27.595746Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Establish a per-TP ledger from the retained S575 journal:4 more FAIL,53 empty-symlink setup UNRESOLVED,1 man precondition UNRESOLVED,9 manual INSPECT. Compare named identities and diagnostics with S561; matching totals alone do not establish parity. Reconcile S355/S371/S377/S385 records and packet/case ownership without duplicate inquiries. Record cause or precise remaining uncertainty, exact evidence, scope, decision owner and next action. Acceptance: all67 identities accounted for, source/artifact/venue identities linked, discrepancy list and reviewed ownership/scope matrix; no assumed product/environment classification.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.

## Worker rules

Read `bashy sprint show 675` (directives D1-D12), `docs/sprint-675-master-execution-plan.md`, `docs/plan-posix-certification-after-separation.md`, `bashy/docs/s575-posix-engineering-baseline.md`, `bashy/docs/s561/a4-licensed-results.md`, and `docs/plan-s571-posix-certification-readiness.md`. Work on current default-branch heads; do not redo Phase 0 pins or run builds/suites/VMs/containers on the dev box. Cite the tested commit (`posix-baseline/s575-2026-11-19`) beside head whenever citing source lines.

Locate the private evidence store, extracted S575 full-D archive, S561 retained licensed/public release directories, and private harness kit via `bashy kb context --for "S575 evidence archive location"`, then read `docs/S575-FULL-D-EVIDENCE-INDEX-20261119.md` in the private harness kit. Re-verify the sealed S575 archive SHA256 (`63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1`, 196 regular files) and `sealed-build-manifest.txt` SHA256 (`6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138`) before use. Stop and notify `agy-gemini4-carbon` via `bashy mb send` immediately if any checksum fails or if any of the 67 identities or per-TP journal diagnostics differ from S561.

Deliverables and isolation:
1. Keep the shared private harness kit checkout clean: create an isolated `git worktree` of the private harness kit on branch `s675-r1` inside the private evidence store (never inside `umbrella`). Write `docs/S675-R1-RESIDUAL-67-LEDGER.tsv` (67 rows, one per residual TP identity, noting the 69 IC occurrences where `test:84` and `leftbrack:84` repeat across two ICs) and `docs/S675-R1-RESIDUAL-67-LEDGER.md`.
2. Reconcile all 117 S575 journals (9,337 execution TPs, 9,270 PASS group, 178 excluded build/setup records, 4 FAIL, 54 UNRESOLVED, 9 INSPECT) by exact `(target:tp)` name and per-TP journal diagnostics against S561's retained licensed journals.
3. Map every row to: raw TET code/verdict (preserved unchanged), assertion class and base-scope applicability (`docs/SPRINT-341-BASE-SCOPE.md`), S575 diagnostic observation, S561 by-name/diagnostic parity, confirmed cause or exact remaining uncertainty (no assumed classification), existing S355/S377 packet (`S355-D-AUTHORITY-BATCH-INDEX-20261002.md`, `S355-D-SYMLINK-53-AUTHORITY-PACKET-20261002.md`, `S355-D-FIVE-TP-AUTHORITY-QUESTIONS-20261002.md`, `S355-D-MORE-OD-AUTHORITY-QUESTIONS-20261002.md`, `S377-INSPECT-NINE-OPERATOR-RESOLUTION.md`, `S377-SYMLINK-VENDOR-SOURCE-COMPARISON-20261006.tsv`), S371/S385 external-decision ownership (`bashy sprint show 371`, `bashy sprint show 385`, and historical preparation records on the workstation including pending VSC inquiry ticket status and confirmation that previously resolved `hash:9`, `od:5,16`, `write:22`, `renice:16`, `kill:9,19` remain PASS-group without duplicate inquiries), Sprint 675 story owner (R2/R3/R4/R5), external/manual decision owner (VSC authority vs operator), and next action. Link exact S575 source/artifact/venue hashes. Do not copy raw licensed test source.
4. Commit the private ledger on branch `s675-r1` in the private kit worktree (do not push `main`; the manager reviews and integrates `s675-r1`).
5. In your `umbrella` weave workspace, append a scrubbed `## S675 R1 Summary` section to this story file with aggregate counts, the 67 named TP identities by family, S561 parity verdict, R2-R5 ownership summary, and the private kit `docs/S675-R1-RESIDUAL-67-LEDGER.{md,tsv}` branch and commit SHA. Public commits must contain zero journal excerpts, correspondence text, credentials, hostnames, OS logins, emails, or home-directory paths (`script/scrub-gate.sh` is fail-closed; describe hosts by role only).
6. Commit in both repositories with `BASHY_AGENT` set to your assigned agent identity and trailers `Sprint: #675`, `Story: #13`, `Story-ID: 4088102f4f39`, `Agent: <assigned-agent>`. Do not push `umbrella` `main`. Submit with `bashy sprint submit 675 4088102f4f39 -m "<summary, umbrella commit SHA, private kit s675-r1 commit SHA>"`.
