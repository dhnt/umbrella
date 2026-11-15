---
id: eea4f787fdba
kind: bug
title: 'S15b outpost: connect/ssh pick the attachment whose satellite hosts the target instead of attachments[0]'
seq: 270
status: assigned
priority: p1
labels:
    - outpost
created: 2026-11-14T04:12:59.048102Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
---

Fleet evidence 2026-11-14 (S23 user-complex, outpost 1dc6d64 built from the sibling): devbox is attached to sat-blue, sat-green, sat-class, sat-partner; win1 (same owner) is attached to sat-green and sat-class only. 'outpost connect --stdin win1' from devbox posted to sat-blue (/matrix/h/win1/elev/ssh -> 404 unknown host: win1) = attachments[0], not the attachment that hosts the target. The suite check 'connect from devbox reaches win1 through sat-class (not sat-blue)' stays red until the selection works; evidence .e2e-multisat/user-complex/evidence.json + runs/user-complex logs on the instance.
