---
id: 51bce80d8432
kind: feature
title: 'S4 First provider family: forge (gh, glab)'
seq: 417
status: todo
priority: p2
labels:
    - yoke
created: 2026-11-17T18:49:46.603804Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: equivalent providers expose different CLIs; one app means one way to use them.
Behavior: generic forge verbs over fleet.Adapter rows with one adapter per provider (gh, glab); envelope-parity fixtures run the same generic request against each provider; native passthrough stays available.
Depends on: S0.
Verification: parity fixtures green by name for both providers in the gate.
