---
id: a4dcdebb5196
kind: feature
title: website.bsh serve on a Windows owner outpost (scheduled task, PowerShell launcher)
seq: 497
status: wontfix
priority: p2
labels:
    - shaping
    - windows
    - superseded
created: 2026-11-18T23:45:47.0751Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:28.824507Z
---

Sprint 615 moved the showcase to the operator's always-on Windows host by hand: a cross-built site-shaping.exe, outpost apps add site --trust-cloud-identity, a start.ps1 launcher holding SITE_SSO_SECRET and SITE_AI_KEY, and a scheduled task (S4U principal, at startup) because an at-logon task never runs on a host nobody is logged into. website.bsh serve should do this natively on Windows (Windows native first), with the secrets out of a plain file (vault or DPAPI).

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Deferred outside the replacement MVP; historical requirement retained, no new deferred story created. Preserve current Windows deployment; new native scheduled-task/PowerShell automation is deferred.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
