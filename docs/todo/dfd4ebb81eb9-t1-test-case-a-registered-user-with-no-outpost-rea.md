---
id: dfd4ebb81eb9
kind: test
title: 'T1 test case: a registered user with no outpost reads Gmail and saves a note into /drive/notes from their agent; outpost online then offline'
seq: 667
status: todo
priority: p2
labels:
    - bashy-hosting
    - test-case
    - future-input
    - train-2
created: 2026-11-23T13:18:04.715419Z
---

Planned vendor: claude. One Bash# skill-script composing gateway run calls. A registered user with no outpost asks their agent (Muse CLI via its connector or stdio, or the claude.ai connector) for their latest Gmail threads and saves a note into /drive/notes: route: hosted, zero spend, no send; then the same prompts with a paired test outpost online (route: sync) and stopped (route: hosted); a /home mount on that outpost answers host offline (exit 3) when stopped; one member action on a shared shaping-enabled app through run shows the existing path untouched. Accept: reproducible from the one script; people and hosts by role; ids recorded; no PII. After H4, H6b and the master ticket. Spec: docs/sprint-691-master-execution-plan.md
