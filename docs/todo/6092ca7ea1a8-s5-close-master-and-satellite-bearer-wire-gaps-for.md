---
id: 6092ca7ea1a8
kind: enhancement
title: S5 Close Master and Satellite Bearer wire gaps for host assignment, satellite detail, and self-unpair
seq: 73
status: done
priority: p1
labels:
    - satellite
    - cloudbox
    - fleet
    - satellite-cli
created: 2026-11-10T01:43:06.695498Z
assignee: codex-gpt6-astra
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
closed: 2026-11-10T05:33:18.439394Z
closed_by: claude-opus5.5-s606
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210).
Dependencies: S1.

Scope
- Expose satellite_id / satellites[] on GET /api/v1/hosts (or accept Bearer auth on GET /api/v1/satellites/assignment) so bashy paired-host list --satellite <id> filters natively instead of returning errNoSatelliteFilter (yoke/pkg/fleet/paired_hosts.go).
- Add GET /api/v1/satellites/:id on Master so bashy satellite show does not need to fetch the full list.
- Support host-authenticated DELETE /api/v1/hosts/self so outpost unpair and outpost satellite detach remove stale host rows automatically without requiring manual bashy fleet prune (closing gaps in yoke/pkg/fleet/reproduce.go).
- A host that unpairs or detaches from a satellite also leaves no stale host-to-satellite assignment on the master (otherwise `--satellite` filtering lists it). Whatever must change on the satellite or master side is filed as a support ticket against the public wire contract.

Acceptance
- Wire contracts and client methods in yoke/pkg/fleet support per-satellite host filtering, direct satellite lookup, and clean host self-delete with fixture coverage.
