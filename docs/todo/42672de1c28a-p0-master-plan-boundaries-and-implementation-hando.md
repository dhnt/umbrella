---
id: 42672de1c28a
kind: requirement
title: P0 Master plan, boundaries and implementation handoff
seq: 130
status: todo
priority: p0
labels:
    - shaping
    - dogfood
created: 2026-11-11T20:10:50.123846Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
---

Session scope: write sprint plan/stories only; do not code, migrate repositories, configure remotes, install binaries, start workers, promote or release. Leave this sprint in backlog, unassigned and unstarted for exit.

Goal: transition bashy itself to software shaping through local installations -> qiangli/* staging -> dhnt/* upstream. Progressive mandatory path: Bash# skill/scripts, then CLI, then coupled native changes. Keep sprint/todo provenance, weave isolation, review and existing gates underneath shaping.

Decisions: existing qiangli repositories are staging; dhnt is new upstream for bashy and explicitly inventoried dependencies. bashsharp/* is a SEPARATE organization and language project: no transfers, renames, remote changes or release-ownership changes there. Preserve existing Go module paths initially. Native macOS, Windows (not WSL), Linux and a second installation exchange/rollback proof are minimum qualification; not every enrolled machine is blocking.

Architecture: source-backed bashy registration; existing shape lifecycle and slot recovery; one editable .bsh orchestration with skill guidance, small existing verbs, Go only for missing primitives. Portable candidate evidence and trusted-service promotion enforcement. Independent retained release controls verification, recovery and self-management. Source promotion is distinct from artifact release and installation.

Inspection: no bashy/review directory exists here. Read bashy/docs/shape-contract.md, bashy/skills/bashy/commands/shape.md, bashy/docs/agentic-block-shaping.md, bashy/docs/sprint-512-bashsharp-skill-run.md, bashy/docs/kb/pages/extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th.md; inspect yoke/pkg/shape/bashy.go and promotion.go and bashy/internal/agentos/shape_local.go and shape_slot.go. Unregistered bashy is report-only; registered bashy with managed source already has source-tier lifecycle. Do not remove refusal guards indiscriminately.

Existing work: Sprint 579 UUID b3b68c8f-69de-5654-bab3-e0665d048fd4 H5 5f0412e066bd and H7 515557c02505 remain qualification work; Sprint 580 UUID 0cae3983-9725-5e31-b45d-3585e97e00de promotion implementation shipped but installed dogfood story 0a10de8d63f2 was carried forward. Coordinate/reuse those story identities and evidence, never claim implementation closure proves multi-host qualification.

Order: P1 baseline -> P2 setup and P3 evidence -> P4 staging promotion -> P5 script pilot -> P6 CLI pilot -> P7 coupled-source pilot -> P8 release ownership -> P9 mandatory cutover. P4 topology audit can begin after P1; enforcement consumes P3. Each pilot gates the next mandatory scope.

Acceptance: future manager rechecks source and installed capabilities, maps dependent stories, names owners and verification lanes, and records exact baseline before implementation. This planning card does not authorize execution. Public records use host roles and opaque installation IDs, never machine names, logins, addresses, credentials or home paths.

Story index (stable references):
P0: todo:42672de1c28a — P0 Master plan, boundaries and implementation handoff
P1: todo:bac372b79573 — P1 Reconcile self-shaping baseline and carried qualification
P2: todo:b0e65f57985c — P2 Reproducible source-backed bashy shaping installations
P3: todo:2c44103207bb — P3 Portable candidate identity and native qualification evidence
P4: todo:c1c795fc06a8 — P4 qiangli staging to dhnt upstream source promotion
P5: todo:e545a503401b — P5 Bash# skill-script dogfood pilot
P6: todo:5560a9e0cdfe — P6 Native CLI self-shaping and recovery pilot
P7: todo:1c3768ba2600 — P7 Coupled-source and protected-runtime shaping pilot
P8: todo:6753d01f856b — P8 Move future official release ownership to dhnt
P9: todo:d37165742155 — P9 Enforce shaping-first delivery and publish final handoff

Exit handoff: planning artifacts saved only. All stories are todo; sprint is backlog with no manager, lease, workers or test-host claims. Next session: select a manager, read P0/P1 and existing linked qualifications, then obtain execution scope before starting. No code/test execution or infrastructure changes occurred in this planning session.
