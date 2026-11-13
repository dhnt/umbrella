---
id: 41637a46ce1c
kind: task
title: 'S2a outpost files: gate the direct loopback File Browser listener (per-boot secret or Host allowlist); check yoke webconsole files panel binding'
seq: 215
status: done
priority: p0
created: 2026-11-13T11:41:20.300148Z
assignee: claude-opus5.5-s631
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
closed: 2026-11-13T12:33:15.388045Z
closed_by: claude-opus5.5-s631
---

Root cause: outpost/cmd/outpost/capability_files.go serves fbembed with AuthMethod NoAuth on 127.0.0.1:<ephemeral>; RequireLogin only gates the tunnel path. Any local process can POST /api/login, receive a JWT and read the scope (home by default), or write when allow_write is on. There is no Host check, so DNS rebinding is plausible. Fix where the cause lives (outpost listener), not in the filebrowser fork. Done = unit test proves direct loopback requests without the secret or with a foreign Host are refused and the tunnel path still works; yoke webconsole panel_files binding checked and gated if exposed.
