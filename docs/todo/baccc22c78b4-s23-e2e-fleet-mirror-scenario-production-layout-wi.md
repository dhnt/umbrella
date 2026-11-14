---
id: baccc22c78b4
kind: test
title: 'S23 e2e: fleet-mirror scenario (production layout with fake accounts/hosts) in the multisat harness, run on a temporary AWS instance, held up for manual verification'
seq: 273
status: assigned
priority: p1
labels:
    - e2e
created: 2026-11-14T11:12:39.658128Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
---

Design settled with the operator 2026-11-14 (after the first draft):
- Fictitious names only; no legacy pairings or migration in the mirror (target state); production is untouched and will be wiped/repaired from the same declaration shape later.
- The space is cloudbox masters (1 now, list for N) x satellites 0..N x outposts 0..N per account. Declaration script/e2e-fleet.json: 11 accounts (operator 3/3, partner 1/2, campus 2/2, hub 1/0, small 1/1, home 1/4, solo 0/1, twin 0/2, student 0/1 attaching to foreign satellites, family 0/0 consumer, company 0/0 superadmin), 9 satellites, 16 outposts, memberships, admission by circle/email, shares.
- One scenario per user shape (user-consumer, user-solo, user-small, user-home, user-single-outpost, user-two-outposts, user-hub, user-two-satellites, user-partner, user-superadmin, user-complex), each with its own fixture slice so they run in parallel (E2E_JOBS); user-complex is the union and the held one (master published on :18443 with dev sign-in links).
- Code layout: script/e2e_fleet/fleet.py (loader, slice fixture, declaration-derived assertions), journeys.py (one journey per shape, environment-agnostic so it can later run read-only against a real master), user_<name>.py suites mirroring the pages; e2e_multisat.py only dispatches.
- Reference: HTML overview generated from the declaration (docs/e2e-fleet-mirror.html, artifact NWCjjF3ho3oVUbgcd6rmm5) + one Markdown page per scenario (docs/e2e-fleet/*.md, viewer book fleet-e2e). Generator script/e2e-fleet-diagram.py.
- Venue: Lightsail s630-e2e (4 GB fits the full fleet, ~800 MB peak). Harness defect found by the first run: set_admit waited on the default satellite when given a sat_id (fix in the harness).
- Missing-case list agreed as candidates: consumer refused before admission, access lost on revoke/removal, pooled /v1 by a consumer; unpair drops everywhere; suite across hosts; member of two owners; detach/re-attach/restart; public vs private app; transfer to non-mutual refused; attach to non-mutual refused; rm --force on the twin; same host name under two owners; lockout + heartbeat heal; membership ended; superadmin step-up listing; scope 403s.
