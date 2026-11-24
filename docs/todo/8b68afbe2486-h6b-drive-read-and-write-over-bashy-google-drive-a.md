---
id: 8b68afbe2486
kind: feature
title: 'H6b drive: (read and write over bashy google drive-*) and gh: (read-only over bashy gh api) mounts for the trove; account bound per mount; hermetic fakes'
seq: 293
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:52.918388Z
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Staffing 2026-11-24: glm, starts when H6 merges (needs its mount seam) and H2 (vault projection).

Planned vendor: glm. Example level, after H2 and H6. Moved from Sprint 639 S4 on 2026-11-23 (the trove is now Sprint 691's virtual drive). drive: via bashy google drive-list|drive-search|drive-get|drive-upload; the mount's account names the vault entry google/<account>/credentials that H2 projects into the call; gh: via bashy gh api (repo tree, issues as entries), read-only (writes stay 639 S4b). Hermetic tests against fake google/gh binaries (pattern examples/google/test_cli_wrapper.py). Accept: trove ls /drive and /repo list and cat; trove put lands in Drive; tests need no live account; one live smoke with the operator's own bring-your-own-project account recorded by role. Spec: docs/sprint-691-master-execution-plan.md; design: docs/trove-content-app-design.md
