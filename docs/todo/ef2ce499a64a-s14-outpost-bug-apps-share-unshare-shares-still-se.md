---
id: ef2ce499a64a
kind: bug
title: 'S14 outpost bug: apps share|unshare|shares still send the pre-S619 {app, circle|email} body; move to the grant-rule form {app, circles[], groups[], emails[]}'
seq: 305
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
    - outpost
    - parity
created: 2026-11-15T00:02:48.835468Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Planned vendor: codex. PUBLIC outpost change, small, separate commit; trove share (S6) shells to this verb so it inherits the bug. Root cause (recorded before the fix): Sprint 619 changed the host-share wire to a strictly decoded grant rule {app, circles[], groups[], emails[]} (400 invalid_request otherwise; S630 S22 fixed the cloudbox console but not outpost); outpost/internal/agent/portal/shares.go CreateHostCircleShare and AppShare still use {app, circle} / Email, and unshare matches on share.Email so rule rows are never found. Fix: rule-form body with repeatable --circle/--group/--email (one rule per call, as bashy suite share does via yoke/pkg/fleet/grant_rule.go), shares lists rule rows, unshare by id; test against yoke/pkg/fleet/cloudboxfake addHostShare. Reproduce first against the fake (expect 400) and record. Accept: fake-server test red then green; outpost apps share APP --circle family creates a rule row and who lists the circle's members; unshare removes it; --json parity. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md

## Re-linked 2026-11-24

Moved from Sprint 639 (closed won't do) to Sprint 703 as a bug (operator rule: every bug still to resolve goes there). Sprint 706 R5 (group shaping grants from the CLI, B3) depends on this fix.
