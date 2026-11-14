---
id: 804b7d9720e0
kind: feature
title: 'S1 trove.bsh: trove.json mounts, mount add|ls|rm (dir:, dir:@host, git:), ls|find|stat|cat emitting bashy-node-v1 + trove attrs'
seq: 290
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:52.485725Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Planned vendor: codex. Example level, bashy/examples/trove/. trove.json = owner-owned mounts {name, locator, account?, grants[], tags[]}; entry = bashy-node-v1 node (yoke/pkg/lens/provider) + attrs mount, owner, grant, provenance{producer, app ref, run/story}, renders[], subject. Slice 1 emits rows from Bash# over bashy lens -t listing (dir:, dir:@host via outpost sftp, git:); --json --fields --dry-run; register.sh (commands add + skill add + app add --type shaped), contract.bsh @effects(read,exec), checks/, synthetic fixtures. Accept: rows pass the bashy-node-v1 validation used by provider/recipe_test.go; trove cat of a peer-host file equals lens output; unknown mount = not-found; checks green under bashy shape verify trove. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md
