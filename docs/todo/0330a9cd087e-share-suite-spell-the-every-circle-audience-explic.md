---
id: 0330a9cd087e
kind: enhancement
title: 'share/suite: spell the ''every circle'' audience explicitly as --circle ''*'' (sent as the empty circles list); refuse a rule that names no circle as ambiguous'
seq: 306
status: todo
priority: p3
labels:
    - boundary
    - parity
    - circle
created: 2026-11-15T00:09:16.85868Z
---

Operator 2026-11-14 (Sprint 639 circle study): on the wire an empty circles list means every mutual member, the opposite pole of owner-only; bashy should make that pole explicit instead of implicit. Apply the trove rule (docs/trove-content-app-design.md, 'The special circle *') to bashy share add HOST/APP and bashy suite share (yoke/pkg/fleet/grant_rule.go, share_grant_cmd.go, suite_cmd.go) and to who/list output ('every circle (all members)'). Wire unchanged. Accept: --circle '*' posts an empty circles list; omitting --circle with --group/--email only is refused with a message naming '*'; existing rows with empty circles display as every circle.
