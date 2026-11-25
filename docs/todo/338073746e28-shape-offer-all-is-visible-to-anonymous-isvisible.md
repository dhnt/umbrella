---
id: "338073746e28"
kind: bug
title: 'shape offer --all is visible to anonymous: isVisible returns offer.All for an empty principal'
seq: 734
status: todo
priority: p3
labels:
    - shaping
created: 2026-11-25T04:09:52.148045Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Found in the Sprint 683 review against Sprint 710's access model (2026-11-24): a satellite admits members; non-members, logged in or not, get only what the owner publishes publicly, as anonymous. Offers of shaped versions should therefore be member-only.

Code inspected (yoke origin/HEAD ac3d38415ece): pkg/src/offer.go isVisible returns offer.All when principal is empty, so ListOffers with no principal lists every --all offering. Adopt still requires a principal (adoptUnlocked refuses an empty one), so this is visibility of offer metadata (app, revision, version, origin), not adoption. Also related: --all resolves to allKnownPrincipals (principal lines in the app repo plus shape/<app> state dirs), not to the owner's members or circles; that wider question is Sprint 683 open decision 4 and is not this bug.

Not yet reproduced: first reproduce with a unit test (ListOffers(home, app, "") returns an --all offering), record the cause, then decide with the 683 decision-4 outcome whether the fix is 'empty principal sees nothing' or 'visibility follows the share'. Plan: docs/sprint-683-master-execution-plan.md (Relation to Sprint 710).
