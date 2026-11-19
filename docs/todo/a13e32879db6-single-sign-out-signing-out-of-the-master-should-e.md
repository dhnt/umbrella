---
id: a13e32879db6
kind: bug
title: 'Single sign-out: signing out of the master should end satellite sessions'
seq: 506
status: todo
priority: p1
labels:
    - cloudbox
    - satellite
    - auth
created: 2026-11-19T06:11:45.594015Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
---

Found in the Sprint 615 live run (2026-11-18, operator): after signing out of the cloudbox master, a shaped site on a satellite still showed the signed-in view, because the satellite keeps its own session cookie on its own origin. Counterpart of 8d8cc6ec (sign-in does not carry to satellites). Want: master sign-out also ends that account's sessions on satellites (front-channel logout fan-out, or a session generation the satellite checks), and a satellite /cloud/logout that accepts ?next= to return to a page. Interim: shaped-site panels offer Sign out on their own origin. Public wire contract only.
