---
id: 0123321b5e80
kind: test
title: 'S3 trove add URL|FILE --to MOUNT + UAT i: AP CSP redesign page -> note -> Gmail draft -> one send with --yes'
seq: 292
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:52.770059Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Planned vendor: claude. trove add ingests via bashy fetch --md into a mount with a write grant. UAT i: trove add https://apcentral.collegeboard.org/courses/ap-computer-science-principles/redesign --to inbox; trove present trove:inbox/ap-csp-redesign.md --as note --for teacher; bashy email --role email.send as a Gmail DRAFT first (draft first, final once), operator review, one send with --yes to the interested party. Accept: reproducible from one .bsh run; no send without --yes; zero spend (oss text route); note.md + svc envelope ids recorded on this story (recipient by role, never an address in the public repo). Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md
