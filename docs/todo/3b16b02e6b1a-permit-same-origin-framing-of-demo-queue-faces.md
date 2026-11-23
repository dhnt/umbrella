---
id: 3b16b02e6b1a
kind: bug
title: Permit same-origin framing of Demo Queue faces
seq: 663
status: todo
labels:
    - page
    - cross-app
created: 2026-11-23T13:10:00.713046Z
---

Sprint 696 story 661 found that examples/demo-queue/server.go sends frame-ancestors 'none' in the loopback middleware and also refuses cross-site requests. The Page proof uses the organizer and projector URLs as a link-out embed block. Define a narrow same-origin opt-in for inline use and validate the projector and organizer together on the gate host with the two capabilities kept separate.
