---
id: 1c3768ba2600
kind: test
title: P7 Coupled-source and protected-runtime shaping pilot
seq: 137
status: todo
priority: p1
labels:
    - shaping
    - dogfood
created: 2026-11-11T20:10:51.205017Z
sprint: 618
sprint_id: deff293a-cb7b-552c-9392-3edf1b388c44
sprint_title: 'Bashy shaping wave 2: coupled-source pilot, dhnt release ownership, shaping-first enforcement'
---

Depends on P6. Deliver one bounded change spanning bashy and a necessary dependency, with an immutable multi-repository source/dependency manifest. Publish staging dependency commits before consumer pins; verify standalone GOWORK=off and integrated behavior; qualify exact integrated source before dhnt promotion. Preserve existing published histories and frozen-baseline policy.

Interpreter/recovery/control-plane candidates run as explicit isolated binaries in test lanes; ordinary shell, scripts and trusted recovery keep the retained release until an approved release update. Do not route candidate authority into its own activation gate.

Acceptance: no workspace-only dependency leakage; named fixture results and relevant layer/conformance gates pass with no new failures or silently lost coverage. Source identity matches tested artifacts across lanes. Recovery remains usable after deliberately broken candidate behavior. Record root cause before repairing any formerly green test. Heavy and licensed suites stay on authorized test venues; restricted evidence stays private.
