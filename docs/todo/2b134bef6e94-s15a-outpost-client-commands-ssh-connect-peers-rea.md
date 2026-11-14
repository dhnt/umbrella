---
id: 2b134bef6e94
kind: bug
title: 'S15a outpost: client commands (ssh, connect, peers, reach, kubectl) treat a pair-once host with attachments as unpaired'
seq: 264
status: done
priority: p1
labels:
    - outpost
created: 2026-11-14T00:46:36.111191Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-14T00:59:36.787924Z
closed_by: claude-fable5.1-s630
---

Found 2026-11-14 right after migrating the dev box from the legacy zoo pairing to pair-once + attachments (S15): outpost ssh exec the second Windows host -> 'local outpost is not paired with cloudbox yet'; even Direct ssh targets refuse (the check runs before the dial). Root cause (product defect): the client CLI paths load agent.json with conf.LoadFile and gate on the legacy top-level fields (ServerAddr/AccessToken); conf.FileConfig.ApplyAttachmentTunnel (the in-memory overlay of attachments[0]) is only applied in 'outpost start' (cmd/outpost/main.go:237), deliberately after tryReattach. Fix where the cause lives: a conf.LoadClientFile helper = LoadFile + ApplyAttachmentTunnel for client-side commands (connect, ssh, ssh_dial, ssh_tree, ssh_runtime, peers, peers_help_mint_invite, reach, kubectl, depart, token, apps_share, mcpclient); start keeps its own ordering. Follow-up (not here): pick the attachment whose satellite hosts the target instead of attachments[0].
