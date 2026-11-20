---
id: fa9fcc8de90d
kind: feature
title: 'bashy dag --makefile: generated, teaching Makefile forwarder from dag.md; pilot in yoke'
seq: 558
status: done
priority: p1
created: 2026-11-20T10:31:08.700554Z
assignee: muse-wonder-full
sprint: 678
sprint_id: e2cf7613-74c4-537f-ad54-327d8dcebbc1
sprint_title: Discover dag.md project tasks through make help
closed: 2026-11-20T20:46:09.06838Z
closed_by: claude-opus5.5
---

Spec: docs/plan-s678-make-dag-bridge.md §S1 (operator decision 2026-11-20: generate the Makefile from whatever dag.md holds, with comments that teach and transition agents to bashy dag). Supersedes the earlier bashy-Makefile make-help pilot (conflicted with the 11-17 Makefile-removal ruling). Acceptance: generator in yoke pkg/dag beside skill.go; header comment (GENERATED, do not edit, native bashy dag usage, --skill export); one rule per dag target forwarding to bashy dag <target> with the target description as comment; fixed help target (dag --list + pointer) unless dag defines help; .DEFAULT forwards; POSIX-only syntax; bashy-missing guard; --check staleness mode; yoke/Makefile generated and checked by a dag target; unit tests + yoke smoke (make help == dag --list targets, make -n test previews, --skill writes SKILL.md to a temp dir, GNU make same help output if present).

Operator addition 2026-11-20: the generated Makefile opens with a framed all-caps banner — GENERATED FILE — DO NOT EDIT; produced from dag.md by bashy dag --makefile; edit dag.md and regenerate; manual changes are overwritten and fail --check (exact text: plan §S1 item 2).
