---
id: 791735df2789
kind: doc
title: 'M4: lockstep release rule + release-pins surface (release-pins-consistent: ycode''s shared sibling pins not older than bashy''s)'
seq: 872
status: todo
priority: p3
labels:
    - core
created: 2026-11-28T21:18:36.27417Z
sprint: 749
sprint_id: 4c411c90-8521-5bd7-bafd-25fd2c4ef4cf
sprint_title: 'Minimal stable core: core verbs = model tool agent commands help version; rest optional'
---

Plan: docs/sprint-749-minimal-core-plan.md (M4). (1) Release-doc paragraph: bash, Bash# and the core contract (yoke/pkg/core) share one version, moving only on a bash/Bash# contract change; the binary release version also moves with builtin optional changes; cite the M0a cache check and the M2 ratchet. (2) Owner 2026-11-28: lift a narrow surface bashy/shapeware/release-pins (kb shapeware-lift-app); file release-pins-consistent tbd; gate 1; build TestSiblingPinsAgree: GOWORK=off at a fixed commit, ycode's version of bash, bashsharp, coreutils, yoke and yoke/pkg/core must be no older than bashy's; spec change to verified. Release order: siblings into bashy, ycode to that bashy, bashy's ycode pin, tag. Origin: todo da93e20e0f6a.
