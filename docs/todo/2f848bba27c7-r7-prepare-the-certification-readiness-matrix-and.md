---
id: 2f848bba27c7
kind: task
title: R7 Prepare the certification-readiness matrix and operator handoff
seq: 19
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:28.278501Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Consolidate R1-R6. Verify current official program/profile/version, kit terms, declared pure-Go102-provider scope and submission requirements before claiming readiness. Reuse existing authority/manual packet formats. Assemble exact candidate/source/build/dependency/harness/fixture/artifact identities, raw-evidence references,67-result disposition ledger,9 inspection packets, received rulings versus prepared questions, minimal repair proposals and affected verification needs. Acceptance: independently reviewed preparation dossier and explicit remaining blockers/owners/next actions. Prepared packets are not rulings; pending required decisions prevent a submission-ready claim. No external send, fees, official claim, source change or release is authorized by this story.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.

## Worker rules

Read `bashy sprint show 675` (directives D1-D12), `docs/sprint-675-master-execution-plan.md`, `docs/plan-posix-certification-after-separation.md`, `bashy/docs/kb/pages/full-profile-d-posix-runbook.md`, `bashy/docs/s575-posix-engineering-baseline.md`, and all private-kit R1-R6 deliverables (`docs/S675-R1-*` through `docs/S675-R6-*`). Locate the private harness kit and evidence store via `bashy kb context --for "S575 evidence archive location"`.

Deliverables and isolation:
1. Verify current official Open Group certification and test-kit sources directly (fetch/check live official URLs and cite check date, exact version numbers, and clauses; mark anything unreachable as UNVERIFIED rather than guessing):
   - Test suite catalogue (`https://posix.opengroup.org/testsuites.html`) and current authorized VSC-PCTS2016 release + OSS time-limited license agreement (`https://posix.opengroup.org/docs/VSC-PCTS2016-TestSuite-TimeLimited-License-Agreement-OSS-v1.4.pdf` or current link).
   - Product Standards and Conformance Statement (`https://posix.opengroup.org/prodstandards.html`, `https://posix.opengroup.org/docs/su-2016.html`, `https://posix.opengroup.org/docs/PX2_2016.html`).
   - Certification Guide (`https://posix.opengroup.org/certification_guide.html`), Certification Policy (`https://posix.opengroup.org/docs/POSIX_Certification_Policy_v1.1.pdf`), and POSIX FAQ (`https://posix.opengroup.org/posixfaq.html`) — covering PR disposition rules for FAIL/UNRESOLVED, manual INSPECT resolution rules, single uninterrupted `tcc` formal journal vs 117-journal diagnostic baseline, registration/fees, and Linux/macOS/Windows platform eligibility.
2. Keep the shared private harness kit checkout clean: create an isolated `git worktree` of the private harness kit on branch `s675-r7` inside the private evidence store, write `docs/S675-R7-CERTIFICATION-READINESS-DOSSIER.md` consolidating exact S575 candidate/source/build/dependency/harness/fixture/artifact/archive SHA256 identities (plus head Go 1.27.2->1.27.4 note), declared 102-provider pure-Go base scope (`92 Go + 10 shell, 0 external, 14 optional`), the 67-residual disposition matrix (explicitly separating received rulings vs pending sent VSC questions vs prepared unsent packets vs 9 cross-vendor-reviewed INSPECT packets awaiting operator decision vs R6 repair/no-repair outcome), official program/kit-terms verification, honest readiness verdict (not submission-ready while required external rulings, operator INSPECT sign-off, license/registrant confirmation, and uninterrupted formal single-journal run remain open), and operator handoff checklist with owners and next actions. Commit on `s675-r7` without pushing `main`.
3. In your `umbrella` weave workspace:
   - Write `docs/sprint-675-posix-readiness.md` (scrubbed public readiness matrix, aggregate counts, 67 residual identities & dispositions, official public Open Group program/kit check, and honest blockers + owners by role — zero restricted journal excerpts, private correspondence bodies, personal emails, credentials, hostnames, OS logins, or home paths; `script/scrub-gate.sh` must pass).
   - Add one line in `docs/INDEX.md` and an abstract in `docs/README.md` per `CLAUDE.md`.
   - Append a scrubbed `## S675 R7 Summary` section to this story file referencing `docs/sprint-675-posix-readiness.md` and the private-kit `s675-r7` commit SHA.
4. No external correspondence, submission, fees, certification claim, code edit, or tag/release. Commit in both repositories with `BASHY_AGENT` set to your assigned agent identity and trailers `Sprint: #675`, `Story: #19`, `Story-ID: 2f848bba27c7`, `Agent: <assigned-agent>`. Submit via `bashy sprint submit 675 2f848bba27c7 -m "<summary, umbrella SHA, private kit s675-r7 SHA>"`.
