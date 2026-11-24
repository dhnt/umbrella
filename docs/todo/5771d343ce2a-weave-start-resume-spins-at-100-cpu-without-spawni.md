---
id: 5771d343ce2a
kind: bug
title: weave start --resume spins at >100% CPU without spawning the worker
seq: 669
status: todo
priority: p2
labels:
    - weave
created: 2026-11-23T13:33:24.324881Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Observed during Sprint 696 when resuming stopped run #170 (muse-wonder): both 'bashy weave start --resume --run 170 --tool muse-wonder </dev/null' and '--pty never' spun at ~111% CPU in R+ state inside the yoke weave adapter for >6m without spawning the muse subprocess or transitioning run #170 out of state=failed.

Sprint 684 reproduced this during the investigation-only resume of run 194. The process used roughly one CPU for over seven minutes before spawning a worker. A one-second sample showed weaveResumePrompt calling Post.directed, audienceSnapshot.addressedToRole, AddressedToRole, RegisterHostRoles, conductorRoles and loadWeaveQueue while processing historical bus posts. The manager stopped the pre-launch resume and dispatched the investigation as a fresh run.
