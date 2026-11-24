---
id: bf5e89e38c78
kind: test
title: R5 Prepare exact-journal evidence for nine manual INSPECT decisions
seq: 17
status: done
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:28.05149Z
assignee: claude-sonnet5.5
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
closed: 2026-11-24T11:30:03.29313Z
closed_by: agy-gemini4-carbon
---

Depends on R1; can proceed independently of authority reply lanes. Reuse existing S377 rules and inspect S575 evidence for stty7,df1,locale1. Prepare nine individual evidence/rationale records for qualified independent review. Historical manual decisions require demonstrated applicability to this journal. Identify missing or contradictory evidence and propose only bounded affected verification if needed. Acceptance: nine complete review packets and explicit reviewer/decision or pending-review status. Preserve original INSPECT codes; no automated PASS or unapproved replay.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.

## Worker rules

**STEP 0 (MANDATORY FIRST ACTION BEFORE ANY `git commit` IN EITHER REPO):** export `BASHY_AGENT=<assigned-agent-name>` (matching the `assignee:` field in this file, e.g. `export BASHY_AGENT=claude-sonnet5.5`) in the SAME shell invocation that runs `git commit` and include `Agent: <assigned-agent-name>` in the commit message trailers — NEVER run a trial `git commit` under the default `agent-weave-issue-*` identity (which logs a hook bypass entry), and verify with `/usr/bin/git log -1` that `Agent: <assigned-agent-name>` matches your assigned agent name BEFORE running `bashy sprint submit`.

Read `bashy sprint show 675` (directives D1-D12, especially D5 and D6), `docs/sprint-675-master-execution-plan.md`, `docs/plan-posix-certification-after-separation.md`, `bashy/docs/s575-posix-engineering-baseline.md`, and the private-kit R1 ledger (`docs/S675-R1-RESIDUAL-67-LEDGER.md` and `.tsv`). Work on current default-branch heads; cite tested commits (`posix-baseline/s575-2026-11-19`: Bash `7855c2f0`, Coreutils `c6569352`, harness `6966bc6`) beside current heads (`5c52281f`, `e0184192`, `103c5d5`) when referencing source lines.

Locate the private evidence store, extracted S575 archive, and private harness kit via `bashy kb context --for "S575 evidence archive location"`, read `docs/S575-FULL-D-EVIDENCE-INDEX-20261119.md`, and re-verify the sealed archive SHA256 (`63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1`) and `sealed-build-manifest.txt` SHA256 (`6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138`) before use.

Deliverables and isolation:
1. Keep the shared private harness kit checkout clean: the private-kit deliverable `s675-r5-worktree/docs/S675-R5-INSPECT-NINE-REVIEW-PACKETS.md` at commit `a279866` on branch `s675-r5` ALREADY passed whole-document cross-vendor review with zero defects — verify `git -C <s675-r5-worktree> rev-parse HEAD` starts with `a279866` and DO NOT modify or re-commit `s675-r5`.
2. Inspect S575 journals `0035be` (`locale:17`), `0060be` (`stty:13,17,18,19,32,85,86`), and `0081be` (`df:7`) — compute and record each S575 journal SHA256 — alongside `host-manifest.tsv`, `run-inputs.start.tsv`, and Coreutils `cmds/df`, `cmds/locale`, `cmds/stty` source.
3. Cross-check `docs/S377-INSPECT-NINE-OPERATOR-RESOLUTION.md` and `docs/S341-INSPECT-NINE-REVIEW-CHECKLIST-20261002.md`. Do NOT copy historical manual PASS decisions automatically: prepare nine individual exact-journal evidence and rationale packets demonstrating whether each S377 rule applies to S575's actual recorded charmap names (`locale:17`; note S377 did not record charmap names, so do not claim S377 accepted `ANSI_X3.4-1968`), portable 6-column 512-byte `df` rows/header/capacity rounding/fixture mounts (`df:7`), and Linux PTY `pty_set_termios` CS8/CREAD/PARENB constraints (`stty:13,17,18,19,32,85,86`, including both sub-observations on `stty:85`; cite `run-arm.sh` lines 52-77 for `pty_command` assembly, line 104 for `script -qefc` execution, and lines 160-174 for the `/dev/pts` ownership guard), or identifying any missing/contradictory evidence. Preserve all nine raw `INSPECT` (code 102) verdicts; record each item's status as `prepared for independent cross-vendor review and operator decision` (per D6, the operator owns the nine INSPECT decisions).
3a. Public `## S675 R5 Summary` wording fix (keeping private-kit `s675-r5` at `a279866` untouched): append a scrubbed `## S675 R5 Summary` section to this story file referencing `s675-r5` commit `a279866` and summarizing the settled findings (`locale:17` O1, `df:7` 17/17 rows, `stty:13,17,18,19,85,86` G1-G3 closed in the suite-free disposable-VM analogue probe, `stty:32` pre-`TCSETS` `isDelayMode` `"cr"` prefix defect on `cread`/`-cread`/`crt` routed to R6 with driver allowance rejected, all nine raw code 102 `INSPECT` verdicts preserved pending independent review and operator decision). State `"No licensed source, verbatim journal excerpts, or host-specific paths are copied here"` — do NOT claim `"Nothing ... journal-derived ... is copied here"` since permitted derived findings are summarized in the section.
4. Boundary rule (private vs public): in private kit files, record derived facts, line numbers, and SHA256s ONLY — NEVER copy licensed suite source lines, embedded suite lists, or verbatim journal blocks, and NEVER include personal names or email addresses. In your `umbrella` weave workspace story summary and commit message, append a scrubbed `## S675 R5 Summary` section with the nine identities, per-item S575 applicability verification summary, raw code 102 preservation, pending independent-review and operator-decision status, and private-kit `s675-r5` commit SHA — NEVER include Open Group ticket numbers, licensed suite script file names or `/tset/` paths, journal excerpts, correspondence text, credentials, hostnames, OS logins, emails, or home-directory paths (`script/scrub-gate.sh` is fail-closed; use host roles only).
5. Investigation only: no production code edits, no builds/suites/VMs/containers on the dev box, no licensed runs, no external correspondence. Commit in both repositories with `BASHY_AGENT` set to your assigned agent identity and trailers `Sprint: #675`, `Story: #17`, `Story-ID: bf5e89e38c78`, `Agent: <assigned-agent>`. Submit via `bashy sprint submit 675 bf5e89e38c78 -m "<summary, umbrella SHA, private kit s675-r5 SHA>"`.

## S675 R5 Summary

Private-kit deliverable: branch `s675-r5`, commit `a279866` (nine individual review packets; passed whole-document cross-vendor review with zero defects; left untouched by this commit). No licensed source, verbatim journal excerpts, or host-specific paths are copied here.

Evidence identity re-verified: sealed S575 archive SHA256 `63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1` and `sealed-build-manifest.txt` SHA256 `6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138` match. Journal SHA256s match the sealed final journal checksums: `0035be` (locale) `3879df89…8413`, `0060be` (stty) `2f7f67e5…d44c`, `0081be` (df) `4e9a7575…1102`. Tested baseline `posix-baseline/s575-2026-11-19` (Bash `7855c2f0`, Coreutils `c6569352`, harness `6966bc6`); Coreutils `cmds/df`, `cmds/locale`, `cmds/stty` are unchanged between the tested commit and current head `e0184192`, so source line references hold at both.

Nine identities, each with its own packet; all raw code 102 `INSPECT` verdicts preserved, no automated PASS, replay, build, suite run or external contact:

- `locale:17`: the S377 comparison method applies; S377 recorded no charmap names, so its result is not inherited. Open point O1: whether the recorded ASCII canonical charmap name satisfies the suite's "POSIX or empty" wording is a reviewer judgment.
- `df:7`: 17/17 rows verified (six columns, 512-byte header, capacity rounding recomputed, four fixture mounts consistent); no gap.
- `stty:13,17,18,19,85,86` (`85` has two sub-observations): the Linux PTY CS8/CREAD/PARENB rationale applies; gaps G1-G3 (PTY measured, kernel delta, flag read-back) are closed in a suite-free disposable-VM analogue probe, and remain open only on the un-replayed S575 journal.
- `stty:32`: rationale rejected. A pre-`TCSETS` `isDelayMode` `"cr"` prefix defect refuses `cread`/`-cread`/`crt` in user space, so the driver-non-support allowance cannot be claimed. Classified as a Coreutils product defect and routed to R6.

Status of all nine: prepared for independent cross-vendor review and operator decision (D6); reviewer and decision pending.
