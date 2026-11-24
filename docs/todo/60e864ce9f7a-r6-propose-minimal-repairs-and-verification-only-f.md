---
id: 60e864ce9f7a
kind: task
title: R6 Propose minimal repairs and verification only for confirmed defects
seq: 18
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:28.165424Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Conditional on a proven defect or supported setup gap from R2-R5. Do not assume the residuals are all external to the product, and do not implement redesign or repairs during this planning scope. Prepare the smallest causal patch proposal in the owning repository, failing control, focused regression/affected licensed verification plan, build/source/artifact impact and rollback. Reuse existing runners; no assertion weakening, skips, added providers or arbitrary timeouts. Acceptance: reviewable evidence-backed proposals for any confirmed defects, or explicit no-repair-needed reasoning. Further implementation and invalidated full runs require concrete authorization.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.

## Worker rules

Read `bashy sprint show 675` (directives D1-D12), `docs/sprint-675-master-execution-plan.md` (findings 4, 5, 6), `docs/plan-posix-certification-after-separation.md`, `bashy/docs/s561/evidence-identity.md`, and the private-kit R1-R5 deliverables (`docs/S675-R1-*` through `docs/S675-R5-*`). Locate the private harness kit and evidence store via `bashy kb context --for "S575 evidence archive location"`.

Deliverables and isolation:
1. Keep the shared private harness kit checkout clean: create an isolated `git worktree` of the private harness kit on branch `s675-r6` inside the private evidence store (never inside `umbrella`), write `docs/S675-R6-REPAIR-PROPOSALS-AND-VERIFICATION.md`, and commit on `s675-r6` without pushing `main`.
2. Evaluate every finding from R2 (`symlink-53`), R3 (`man:4`), R4 (`more:130,132,133,134`), and R5 (`INSPECT-9`):
   - For any **confirmed** product or harness setup defect proven by R2-R5 evidence, write a minimal causal repair proposal naming the exact owning repository/file/function (tested commit + current head), failing suite-free control, focused unit and regression verification plan (including both Bash/POSIX 86/86 and Bash# regression gates if shared engine/CLI is affected), Go 1.27.4 toolchain and artifact-closure impact (do not reuse Go 1.27.2 artifact evidence for changed inputs), bounded licensed rerun request (proposal only, on disposable ephemeral DO venue requiring explicit operator approval), and rollback. Make NO production code edits.
   - For families where R2-R5 establish external authority/specification questions, host kernel constraints, optional-target scope questions, or manual-inspection dispositions with no proven product/setup defect, record explicit evidence-backed **no-repair-needed** reasoning per family and explain why speculative code workarounds, weakened assertions, skips, or added external providers are prohibited.
3. Boundary rule (private vs public, enforced before any push):
   - Private kit files (`docs/S675-R6-*`): record derived facts, product source citations, line numbers, and SHA256s ONLY — NEVER copy licensed suite source lines, embedded suite command/name lists, or verbatim journal blocks, and NEVER include personal names or personal email addresses.
   - Public `umbrella` files and commit messages: append a scrubbed `## S675 R6 Summary` section to this story file recording per-family repair vs no-repair conclusions, verification/toolchain impact notes, and the private-kit `s675-r6` commit SHA — NEVER include Open Group ticket numbers, licensed suite script file names or `/tset/` paths, journal excerpts, correspondence text, credentials, hostnames, OS logins, emails, or home-directory paths (`script/scrub-gate.sh` is fail-closed, and human review checks these before push; use host roles only).
4. Commit in both repositories with `BASHY_AGENT` set to your assigned agent identity and trailers `Sprint: #675`, `Story: #18`, `Story-ID: 60e864ce9f7a`, `Agent: <assigned-agent>`. Submit via `bashy sprint submit 675 60e864ce9f7a -m "<summary, umbrella SHA, private kit s675-r6 SHA>"`.
