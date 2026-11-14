---
id: c71da20d8ed2
kind: feature
title: 'S19 cloudbox: satellites have no display name of their own; auto-ID satellites without a provisioning record show as the endpoint hostname'
seq: 267
status: assigned
priority: p2
created: 2026-11-14T02:50:09.455636Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
---

Operator 2026-11-14: in the gmail account's Satellites page a shared satellite (ivy, sat-d2a59c1a89d5) is listed as its sslip hostname instead of its name. Root cause: entity.Satellite carries no name; displayNameFrom(id, provisioningRequest.Name, endpoint) uses the OWNER's provisioning record, else the ID when operator-chosen, else the endpoint hostname for master-generated IDs. Hand-made satellites with auto IDs (ivy) therefore have no name for anyone; the outpost 'satellite list' shows the same. Fix: Name column on Satellite (schema 25), set from POST /api/v1/satellites {name} at creation and by the owner via PUT (yoke: bashy satellite set-name|rename ID NAME), used by directory, host cards, satellite list, upgrade-target and the SPA; provisioning name stays as fallback. Needs a release (migrate job).
