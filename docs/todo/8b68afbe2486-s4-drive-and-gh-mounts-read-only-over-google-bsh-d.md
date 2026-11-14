---
id: 8b68afbe2486
kind: feature
title: 'S4 drive: and gh: mounts (read-only) over google.bsh drive verbs and bashy gh / pure-Go git; account bound per mount; hermetic fakes'
seq: 293
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:52.918388Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Planned vendor: glm. Example level. drive: via bashy google drive-list|drive-search|drive-get (gws BYOP account named on the mount; drive.read rod where present); gh: via bashy gh api (repo tree, issues as entries) or git: for checked-out repos. Hermetic tests against fake google/gh binaries (pattern examples/google/test_cli_wrapper.py). Accept: trove ls trove:drive/ and trove:repo/ list and cat; tests need no live account; one live smoke with the operator's BYOP account recorded by the operator. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md
