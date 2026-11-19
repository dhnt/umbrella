---
id: 85356bd25ce2
kind: feature
title: 'S20 youtube-upload verb in the Google example + kb runbook: publish a video and link it from an app'
seq: 504
status: todo
priority: p2
labels:
    - youtube
    - google
    - kb
created: 2026-11-19T04:33:36.188634Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enabled simple site: showcase MVP on the operator''s résumé site'
---

Operator 2026-11-18: agents should publish a demo or tutorial video for any bashy user and link it from an app; a common operation for all users, generic (never hardwired to one account). gws has no YouTube service, so examples/google youtube-upload calls the YouTube Data API v3 resumable upload with the account's own OAuth credentials (default unlisted; prints watch and embed URLs; dry-run plan names the two one-time owner steps: youtube.upload scope and the API enabled). kb page kb/defaults/pages/publish-a-video-to-youtube-and-link-it-from-an-app.md. Hermetic dry-run test.
