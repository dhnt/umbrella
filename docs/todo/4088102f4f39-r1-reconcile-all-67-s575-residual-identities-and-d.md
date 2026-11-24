---
id: 4088102f4f39
kind: requirement
title: R1 Reconcile all 67 S575 residual identities and decision ownership
seq: 13
status: done
priority: p0
labels:
    - posix-cert
created: 2026-11-05T04:19:27.595746Z
assignee: codex-gpt6-sol
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
closed: 2026-11-24T11:19:50.372463Z
closed_by: agy-gemini4-carbon
---

Establish a per-TP ledger from the retained S575 journal:4 more FAIL,53 empty-symlink setup UNRESOLVED,1 man precondition UNRESOLVED,9 manual INSPECT. Compare named identities and diagnostics with S561; matching totals alone do not establish parity. Reconcile S355/S371/S377/S385 records and packet/case ownership without duplicate inquiries. Record cause or precise remaining uncertainty, exact evidence, scope, decision owner and next action. Acceptance: all67 identities accounted for, source/artifact/venue identities linked, discrepancy list and reviewed ownership/scope matrix; no assumed product/environment classification.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.

## Worker rules

Read `bashy sprint show 675` (directives D1-D12), `docs/sprint-675-master-execution-plan.md`, `docs/plan-posix-certification-after-separation.md`, `bashy/docs/s575-posix-engineering-baseline.md`, `bashy/docs/s561/a4-licensed-results.md`, and `docs/plan-s571-posix-certification-readiness.md`. Work on current default-branch heads; do not redo Phase 0 pins or run builds/suites/VMs/containers on the dev box. Cite the tested commit (`posix-baseline/s575-2026-11-19`) beside head whenever citing source lines.

Locate the private evidence store, extracted S575 full-D archive, S561 retained licensed/public release directories, and private harness kit via `bashy kb context --for "S575 evidence archive location"`, then read `docs/S575-FULL-D-EVIDENCE-INDEX-20261119.md` in the private harness kit. Re-verify the sealed S575 archive SHA256 (`63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1`, 196 regular files) and `sealed-build-manifest.txt` SHA256 (`6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138`) before use.

Supervisor D10a/D10b ruling and 67-row keying (already confirmed — do NOT stop on venue-variant diagnostics):
- **D10a (venue-variant data is NOT a stop):** Differences in live filesystem sizes/block counts (specifically `df:7` in `0081be`, code 102 `INSPECT`, where `/` used blocks are `41054640` [26%] in S575 vs `43607640` [28%] in S561 across two separate disposable Ubuntu 24.04 droplets), timestamps, PIDs, hostnames, temporary paths, or device numbers do NOT trigger a D10 stop. Record `df:7` in the R1 discrepancy list as `venue-variant` with both S575 and S561 figures, and mark `df:7` (along with all nine `INSPECT` items) for judgement on the S575 journal in R5. Stop and notify `agy-gemini4-carbon` via `bashy mb send` ONLY under **D10b**: if the set of `(tset, IC, TP)` identities differs, a raw verdict code differs, assertion text differs, or a diagnostic differs in substance.
- **67-row keying (`0063be` resolution):** Key the ledger by `tset_path + ic + tp` (from each `10|` tset header + `220|` IC and TP across all 117 journals: 9,337 execution `220` records + 178 non-execution `220` build/setup records = 9,515 total), NOT by journal target alias alone. Journal `0063be` (target `test`) executes BOTH `/tset/POSIX.cmd/test/test.ex` (IC 1 TP 84 = `test:84`) and `/tset/POSIX.cmd/test/leftbrack.ex` (IC 5 TP 84 = `leftbrack:84`), yielding **67 distinct `(tset_path, ic, tp)` residual identities across 67 raw `220` residual lines** (`4 FAIL`, `54 UNRESOLVED` = 53 empty-symlink + 1 `man:4`, `9 INSPECT`), 100% matching S561. Also note in prose why older S355 docs cited 55 symlink journal occurrences (older S341/S355 ran `[` as a duplicate separate set, whereas S377/S561/S575's 117-target runner executes `0063be` once containing both `test.ex` and `leftbrack.ex`). State both `tset` paths explicitly in the ledger so the operator sees why the count is 67.

Deliverables and isolation:
1. Keep the shared private harness kit checkout clean: create an isolated `git worktree` of the private harness kit on branch `s675-r1` inside the private evidence store (never inside `umbrella`). Write `docs/S675-R1-RESIDUAL-67-LEDGER.tsv` (67 rows, one per residual TP identity, noting the 69 IC occurrences where `test:84` and `leftbrack:84` repeat across two ICs) and `docs/S675-R1-RESIDUAL-67-LEDGER.md`.
2. Reconcile all 117 S575 journals (9,337 execution TPs, 9,270 PASS group, 178 excluded build/setup records, 4 FAIL, 54 UNRESOLVED, 9 INSPECT) by exact `(target:tp)` name and per-TP journal diagnostics against S561's retained licensed journals.
3. Map every row to: raw TET code/verdict (preserved unchanged), assertion class and base-scope applicability (`docs/SPRINT-341-BASE-SCOPE.md`), S575 diagnostic observation, S561 by-name/diagnostic parity, confirmed cause or exact remaining uncertainty (no assumed classification), existing S355/S377 packet (`S355-D-AUTHORITY-BATCH-INDEX-20261002.md`, `S355-D-SYMLINK-53-AUTHORITY-PACKET-20261002.md`, `S355-D-FIVE-TP-AUTHORITY-QUESTIONS-20261002.md`, `S355-D-MORE-OD-AUTHORITY-QUESTIONS-20261002.md`, `S377-INSPECT-NINE-OPERATOR-RESOLUTION.md`, `S377-SYMLINK-VENDOR-SOURCE-COMPARISON-20261006.tsv`), S371/S385 external-decision ownership (`bashy sprint show 371`, `bashy sprint show 385`, and historical preparation records on the workstation including pending VSC inquiry ticket status and confirmation that previously resolved `hash:9`, `od:5,16`, `write:22`, `renice:16`, `kill:9,19` remain PASS-group without duplicate inquiries), Sprint 675 story owner (R2/R3/R4/R5), external/manual decision owner (VSC authority vs operator), and next action. Link exact S575 source/artifact/venue hashes. Do not copy raw licensed test source.
4. Commit the private ledger on branch `s675-r1` in the private kit worktree (do not push `main`; the manager reviews and integrates `s675-r1`).
5. In your `umbrella` weave workspace, append a scrubbed `## S675 R1 Summary` section to this story file with aggregate counts, the 67 named TP identities by family, S561 parity verdict, R2-R5 ownership summary, and the private kit `docs/S675-R1-RESIDUAL-67-LEDGER.{md,tsv}` branch and commit SHA. Public commits must contain zero journal excerpts, correspondence text, credentials, hostnames, OS logins, emails, or home-directory paths (`script/scrub-gate.sh` is fail-closed; describe hosts by role only).
6. Commit in both repositories with `BASHY_AGENT` set to your assigned agent identity and trailers `Sprint: #675`, `Story: #13`, `Story-ID: 4088102f4f39`, `Agent: <assigned-agent>`. Do not push `umbrella` `main`. Submit with `bashy sprint submit 675 4088102f4f39 -m "<summary, umbrella commit SHA, private kit s675-r1 commit SHA>"`.

## S675 R1 Summary

The sealed S575 archive and build manifest SHA256 values above were re-verified, with 196 regular archive files. All 117 S575 journals reconcile to 9,515 raw result records: 178 build/setup records excluded and 9,337 execution TPs. The execution results remain 9,270 in the certification PASS group, 4 FAIL, 54 UNRESOLVED and 9 INSPECT. The 67 residuals have 67 distinct `(tset path, IC, TP)` identities and raw codes matching S561. Their per-TP diagnostic bodies match except `df:7` live filesystem figures, a recorded venue variant under D10a. All nine INSPECT items require a fresh decision on the S575 journal. No product or environment classification follows from the aggregate parity.

- **53 empty-symlink setup UNRESOLVED (R2):** `awk:543`, `bc_03:48`, `cat:25`, `cd:41`, `chgrp:53`, `chmod:57`, `chown:56`, `cksum_03:15`, `cmp:26`, `comm:32`, `cp:97`, `cut:43`, `dd:61`, `df:30`, `diff:64`, `du:43`, `ed_14:47`, `env:27`, `file:64`, `find:142`, `fold:46`, `grep:139`, `head:41`, `iconv:28`, `join:47`, `leftbrack:84`, `ln:59`, `localedef:52`, `ls:107`, `m4:101`, `mkdir:60`, `mkfifo:48`, `mv:87`, `od:64`, `paste:43`, `pax:242`, `pr:56`, `pwd:17`, `rm:56`, `rmdir:30`, `sed:272`, `sh_03:163`, `sort:86`, `split:42`, `tail:48`, `test:84`, `touch:63`, `tsort:20`, `uniq:58`, `uudecode:34`, `uuencode:25`, `wc:32`, `xargs:44`.
- **1 command-count precondition UNRESOLVED (R3):** `man:4`.
- **4 FAIL (R4):** `more:130`, `more:132`, `more:133`, `more:134`.
- **9 manual INSPECT (R5):** `df:7`, `locale:17`, `stty:13`, `stty:17`, `stty:18`, `stty:19`, `stty:32`, `stty:85`, `stty:86`.

The two `test:84` and `leftbrack:84` residuals are distinct executable paths in one `0063be` journal. Each has a separate non-residual IC at TP84, explaining 69 same-TP IC occurrences without adding residuals. Older S355 55-occurrence symlink wording reflects a duplicate `[` set in that earlier runner. Current base-scope review marks `more` and `localedef` as optional targets, with per-TP applicability and official report treatment still open; raw verdicts are unchanged. R2-R4 reuse the S355 packets and the existing Sprint 385 VSC decision queue, with no duplicate inquiry. R5 prepares nine exact-journal reviews for operator judgement, using S377 criteria only as historical context. Historical `hash:9`, `od:5,16`, `renice:16`, `kill:9,19` are raw PASS in both runs; `write:22` is raw WARNING in the PASS group. None is a current residual.

The private per-TP evidence and ownership matrix are committed on harness-kit branch `s675-r1` at `2f59b6f` in `docs/S675-R1-RESIDUAL-67-LEDGER.md` and `docs/S675-R1-RESIDUAL-67-LEDGER.tsv`. The manager and operator review gates remain open; this summary records no authority ruling or manual disposition.
