---
id: 9f80555a4c41
kind: feature
title: 'F1 designated folders: files app serves a list of shared folders with app-share audiences (bashy files share/unshare/shares)'
seq: 834
status: todo
priority: p1
created: 2026-11-27T15:44:28.647256Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands as a service: offer bashy commands to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §3 Shared folders, §4 F1. The outpost files app (File Browser, human surface) serves one confined root (settings.scope, default HOME), read-only unless allow_write. Generalize to a list of designated folders (old scope = one entry), each shared with the app-share audience rule (--circle/--group/--email); os.Root confinement (no symlink/.. escape); read-only by default, --write settable from the host only. Code inspected 2026-11-27: outpost cmd/outpost capability_files.go, apps_share.go; yoke pkg/fleet/baseline/services/files.yaml, pkg/webconsole panel_files.go.
