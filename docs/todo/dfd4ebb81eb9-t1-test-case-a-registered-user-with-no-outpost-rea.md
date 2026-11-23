---
id: dfd4ebb81eb9
kind: test
title: 'T1 test case: a registered user with no outpost reads Gmail and saves a note into /drive/notes from their agent; outpost online then offline'
seq: 667
status: todo
priority: p1
labels:
    - bashy-hosting
    - test-case
created: 2026-11-23T13:18:04.715419Z
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Planned vendor: claude. One Bash# skill-script composing gateway run calls. A registered user with no outpost asks their agent (Muse CLI via its connector or stdio, or the claude.ai connector) for their latest Gmail threads and saves a note into /drive/notes: route: hosted, zero spend, no send; then the same prompts with a paired test outpost online (route: sync) and stopped (route: hosted); a /home mount on that outpost answers host offline (exit 3) when stopped; one member action on a shared shaping-enabled app through run shows the existing path untouched. Accept: reproducible from the one script; people and hosts by role; ids recorded; no PII. After H4, H6b and the master ticket. Spec: docs/sprint-691-master-execution-plan.md
