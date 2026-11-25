---
id: f429bd3eeb40
kind: bug
title: 'bashsharp go test ./...: 44 tests fail standalone because they build sibling cmd/bashy and cmd/bash, which aren''t in the module (pre-existing at 08fabb33)'
seq: 743
status: todo
priority: p2
labels:
    - test
    - pre-existing
created: 2026-11-25T06:49:42.580267Z
sprint: 713
sprint_id: 867b4689-21ed-53db-93f9-b2a926b28de6
sprint_title: 'Known reds triage after train 1: decide fix or won''t do for each pre-existing test red'
---

Seen 2026-11-25 by the Sprint 699 pin bump gate (gate host WSL lane 2, root, Go 1.27.4, GOWORK=off). The same 44 test names fail at baseline 08fabb33 and at candidate 63a30e23, e.g. TestAgentTUINativeOverPTY: 'building cmd/bashy: no required module provides package github.com/qiangli/bashy/cmd/bashy'; TestBashProcessCompletesBackgroundBuiltinOutput: same for github.com/qiangli/bash/cmd/bash. Classification: test defect (the tests assume the workspace siblings that go.work provides; under GOWORK=off they can't build them). Fix where the cause lives: skip with a clear reason, or take the binaries from BASHY_BIN/env, when the sibling packages aren't resolvable. Not touched during train 1.
