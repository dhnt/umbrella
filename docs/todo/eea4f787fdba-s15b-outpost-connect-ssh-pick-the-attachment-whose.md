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

Found 2026-11-14 while migrating the novigens hosts: 'outpost connect <novigens host>' from the dev box (attached to zoo, lern-si, zoo-aws, alien) answered 404 unknown host because the client overlay always uses attachments[0] (zoo) and the target lives on alien. Root cause: ApplyAttachmentTunnel overlays the first attachment only; client paths (connect, ssh relay, ssh dial, ssh runtime, admincore dialSSHChain for 'ssh exec') never consult the other attachments. Fix: a selection step that asks each attached satellite's /api/v1/ssh/hosts for the target and overlays the matching attachment (first attachment as the fallback), shared by the CLI and the daemon's dial; unit test with two fake satellites.
