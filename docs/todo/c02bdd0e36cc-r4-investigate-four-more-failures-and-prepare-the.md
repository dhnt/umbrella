---
id: c02bdd0e36cc
kind: question
title: R4 Investigate four more failures and prepare the scope recommendation
seq: 16
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:27.94053Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Depends on R1. Investigate actual S575 more TPs130/132/133/134, including retained LANG/LC_ALL/LC_COLLATE/LC_CTYPE helper diagnostics, against the exact frozen source and original venue. Compare historical S355 final-EOF/editor questions rather than assuming they explain these failures. Classify proven cause or uncertainty and required/optional certification scope. Acceptance: four individually evidenced findings and reviewed minimal repair or authority/scope recommendation, with the existing packet refreshed. Preserve all four raw FAILs; no silent optional exclusion or implementation changes.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.

## Worker rules

Read `bashy sprint show 675` (directives D1-D12), `docs/sprint-675-master-execution-plan.md` (especially finding 8), `docs/plan-posix-certification-after-separation.md`, `bashy/docs/s575-posix-engineering-baseline.md`, and the private-kit R1 ledger (`docs/S675-R1-RESIDUAL-67-LEDGER.md` and `.tsv`). Work on current default-branch heads; cite tested commits (`posix-baseline/s575-2026-11-19`: Bash `7855c2f0`, Coreutils `c6569352`, harness `6966bc6`) beside current heads (`5c52281f`, `e0184192`, `103c5d5`) when referencing source lines.

Locate the private evidence store, extracted S575 archive, and private harness kit via `bashy kb context --for "S575 evidence archive location"`, read `docs/S575-FULL-D-EVIDENCE-INDEX-20261119.md`, and re-verify the sealed archive SHA256 (`63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1`) and `sealed-build-manifest.txt` SHA256 (`6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138`) before use.

Deliverables and isolation:
1. Keep the shared private harness kit checkout clean: create an isolated `git worktree` of the private harness kit on branch `s675-r4` inside the private evidence store (never inside `umbrella`), write `docs/S675-R4-MORE-FOUR-FAIL-ANALYSIS.md`, and commit on `s675-r4` without pushing `main`.
2. Inspect S575 journal `0091be` individually for `more:130`, `more:132`, `more:133`, and `more:134` (all raw code 1 `FAIL`), including every retained `LANG`/`LC_ALL`/`LC_COLLATE`/`LC_CTYPE` and locale-helper diagnostic, `POSIX2_UPE=undefined`, Coreutils `cmds/more` source, and harness `vi` shim/provider wiring at `6966bc6`.
3. Compare against `docs/S355-D-MORE-OD-AUTHORITY-QUESTIONS-20261002.md` and Sprint 377/385 historical final-EOF `v`-command context without assuming historical findings explain S575's journal output: separate what S575's retained journal directly proves from any inner-transcript gap. Check `more`'s required vs optional `[UP]` scope at the source (`docs/SPRINT-341-BASE-SCOPE.md` 14 optional exclusions, POSIX.1-2016 `more` `[UP]` marking, and kit scope configuration), preserve all four raw `FAIL` codes (no silent exclusion), and prepare the refreshed scope/authority recommendation (notifying the manager on `mb` if and only if evidence establishes a confirmed product/setup defect for R6). Do not copy raw suite source.
4. In your `umbrella` weave workspace, append a scrubbed `## S675 R4 Summary` section to this story file recording the four individual TP findings, scope classification, disposition/blocker status (raw FAILs preserved; pending authority/scope decision, not PASS), and private-kit `s675-r4` commit SHA. Zero journal excerpts, correspondence text, credentials, hostnames, OS logins, emails, or home-directory paths (`script/scrub-gate.sh` is fail-closed; use host roles only).
5. Investigation only: no production code edits, no builds/suites/VMs/containers on the dev box (small probes only on a claimed gate-host lane if needed, released after), no licensed runs, no external correspondence. Commit in both repositories with `BASHY_AGENT` set to your assigned agent identity and trailers `Sprint: #675`, `Story: #16`, `Story-ID: c02bdd0e36cc`, `Agent: <assigned-agent>`. Submit via `bashy sprint submit 675 c02bdd0e36cc -m "<summary, umbrella SHA, private kit s675-r4 SHA>"`.
