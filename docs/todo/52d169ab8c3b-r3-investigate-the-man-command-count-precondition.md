---
id: 52d169ab8c3b
kind: question
title: R3 Investigate the man command-count precondition and prepare resolution
seq: 15
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:27.827032Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Depends on R1. Verify the exact current man:4 prerequisite observation:109 available names versus a greater-than109 test before man is invoked. Inspect source, configuration, declared scope and original inventory; reuse the S355 question. Do not invent names or introduce external utilities to satisfy a count. Prepare the root-cause analysis and supported resolution/authority question with evidence. Acceptance: proven prerequisite/control-flow evidence, explicit scope/provider impact and reviewed recommendation or exact authority question; any repair remains a proposal.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.

## Worker rules

Read `bashy sprint show 675` (directives D1-D12), `docs/sprint-675-master-execution-plan.md`, `docs/plan-posix-certification-after-separation.md`, `bashy/docs/s575-posix-engineering-baseline.md`, and the private-kit R1 ledger (`docs/S675-R1-RESIDUAL-67-LEDGER.md` and `.tsv`). Work on current default-branch heads; cite tested commits (`posix-baseline/s575-2026-11-19`: Bash `7855c2f0`, Coreutils `c6569352`, harness `6966bc6`) beside current heads (`5c52281f`, `e0184192`, `103c5d5`) when referencing source lines.

Locate the private evidence store, extracted S575 archive, and private harness kit via `bashy kb context --for "S575 evidence archive location"`, read `docs/S575-FULL-D-EVIDENCE-INDEX-20261119.md`, and re-verify the sealed archive SHA256 (`63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1`) and `sealed-build-manifest.txt` SHA256 (`6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138`) before use.

Deliverables and isolation:
1. Keep the shared private harness kit checkout clean: create an isolated `git worktree` of the private harness kit on branch `s675-r3` inside the private evidence store (never inside `umbrella`), write `docs/S675-R3-MAN-TP4-PRECONDITION-PACKET.md`, and commit on `s675-r3` without pushing `main`.
2. Inspect S575 journal `0089be` for `man:4` (raw code 2 `UNRESOLVED`: `test "109" -gt 109` before `man` executes), `POSIX2_SW_DEV=undefined` configuration, Coreutils `cmds/man` and `cmds/getconf` source, and the declared 102-provider pure-Go base inventory (`92 Go + 10 shell, 0 external`).
3. Cross-check `docs/S355-D-FIVE-TP-AUTHORITY-QUESTIONS-20261002.md`, `docs/SPRINT-341-BASE-SCOPE.md`, and Sprint 385 external-decision records. Prove the control flow (72+37 unconditional list entries = 109 vs strict `>109` check when `POSIX2_SW_DEV`/`POSIX2_C_DEV` are `undefined`), explain why `man` is a mandatory base target (not `[UP]`) and why Bashy's target list / `gencat` cannot alter this count, confirm no invented utility names or weakened prerequisites are proposed, and prepare the refreshed unsent authority question with S575 provenance. Preserve raw `UNRESOLVED` code 2; do not copy raw suite source.
4. In your `umbrella` weave workspace, append a scrubbed `## S675 R3 Summary` section to this story file recording the `man:4` control-flow evidence, base-scope/provider boundary impact, external-blocker status (pending VSC ruling, not PASS), and private-kit `s675-r3` commit SHA. Zero journal excerpts, correspondence text, credentials, hostnames, OS logins, emails, or home-directory paths (`script/scrub-gate.sh` is fail-closed; use host roles only).
5. Investigation only: no production code edits, no builds/suites/VMs/containers on the dev box, no licensed runs, no external correspondence. Commit in both repositories with `BASHY_AGENT` set to your assigned agent identity and trailers `Sprint: #675`, `Story: #15`, `Story-ID: 52d169ab8c3b`, `Agent: <assigned-agent>`. Submit via `bashy sprint submit 675 52d169ab8c3b -m "<summary, umbrella SHA, private kit s675-r3 SHA>"`.
