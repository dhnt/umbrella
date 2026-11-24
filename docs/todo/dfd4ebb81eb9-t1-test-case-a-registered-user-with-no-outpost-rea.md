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
sprint: 699
sprint_id: f30c730a-f8ad-57ba-9122-6f1c2a1cd97a
sprint_title: 'Release train 1: one hosted-plane deploy for Sprints 682/697 + live verification'
---

Planned vendor: claude. One Bash# skill-script composing gateway run calls. A registered user with no outpost asks their agent (Muse CLI via its connector or stdio, or the claude.ai connector) for their latest Gmail threads and saves a note into /drive/notes: route: hosted, zero spend, no send; then the same prompts with a paired test outpost online (route: sync) and stopped (route: hosted); a /home mount on that outpost answers host offline (exit 3) when stopped; one member action on a shared shaping-enabled app through run shows the existing path untouched. Accept: reproducible from the one script; people and hosts by role; ids recorded; no PII. After H4, H6b and the master ticket. Spec: docs/sprint-691-master-execution-plan.md
