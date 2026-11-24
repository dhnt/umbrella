---
id: 96eb974c3482
kind: feature
title: 'S4b GitHub-backed mount: gh:/git: read and write (sliced from S4 for the journey''s rung 2)'
seq: 307
status: wontfix
priority: p1
labels:
    - software-shaping
    - trove
created: 2026-11-15T02:03:41.413774Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
closed: 2026-11-24T18:21:01.550458Z
---

The MVP slice of Sprint 639 S4 (8b68afbe2486), which keeps Drive and the rest. A person's virtual space must be backed by a store they already own, and for the MVP that store is GitHub.

Scope: a trove mount whose source is a git remote or a GitHub repo, through pure-Go git and bashy gh; trove ls|stat|cat read it; a write lands as a commit on a branch in that repo (never a force push, never the default branch). Account bound per mount. Hermetic fakes for tests; one live smoke recorded by the operator.

Depends on 639 S1 (trove.bsh, moved to this card). Out of scope: drive:, mail:, cal:, app: mounts; presenters; the explorer page.

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The account tier (accounts without an outpost) is served by Sprint 691 H6/H6b, the trove as the virtual drive. Retired, not delivered.
