---
id: 9a4a7b8b3933
kind: bug
title: F3 bashy git supports commit -c NAME=VALUE and --allow-empty
seq: 462
status: wontfix
priority: p2
labels:
    - git
    - yoke
    - superseded
created: 2026-11-18T18:32:34.177938Z
sprint: 662
sprint_id: 4a1de847-5d33-5688-abf3-1a3b7903d26d
sprint_title: Shaping friction found by Sprint 655
closed: 2026-11-19T14:02:26.389087Z
---

Problem: 'git -c user.name=t -c user.email=t@example.invalid commit -q --allow-empty -m init' under bashy fails: 'is not served by the native git engine; retry with --external=true ... not supported by the pure-Go implementation' (yoke/git). Sprint 655 fell back to the host git. Agents and shaping recipes (bashy/examples/shaping/hello-world/register.sh uses 'git -c user.name=... commit') rely on these forms.
Behavior: the native engine serves top-level '-c NAME=VALUE' (at least user.name/user.email) and 'commit --allow-empty', or refuses with exit 2 naming the unsupported option. Root cause first: confirm which part (global -c parsing or --allow-empty) is unsupported.
Depends on: none.
Verification: the exact command above succeeds in a fresh repo under bashy; Hello World register.sh runs without host git; existing yoke git tests green.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Deferred outside the replacement MVP; historical requirement retained, no new deferred story created. Global -c parsing already exists; --allow-empty remains a defect but is outside MVP unless a required journey proves it blocks delivery.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
