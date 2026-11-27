---
id: 9f80555a4c41
kind: feature
title: 'F1 outpost.shares capability: one gated files-NAME app per designated folder (os.Root + ServeContent)'
seq: 834
status: todo
priority: p1
created: 2026-11-27T15:44:28.647256Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 F1. File Browser (fbembed) is single-instance, one root, no ETag, no identity pass-through (fork embed.go:20-104): keep it as the owner's browser, unchanged. New capability outpost.shares, settings.folders {NAME: DIR}, registers one app files-NAME per folder (RegisterWithMetaDialer, RequireLogin, one in-memory listener, capability_support.go:150-155); per-app audience via existing outpost apps share files-NAME (no new audience code). Handler: os.OpenInRoot (no symlink/.. escape) + http.ServeContent (Range, HEAD, Last-Modified) + weak ETag from size+mtime + JSON listing for dirs; read-only. ~200-300 lines + tests. Code inspected 2026-11-27 (revised after review): outpost cmd/outpost capability_files.go capabilities.go:90-97 main.go:369 capability_support.go, internal/agent apps.go:466-486,1196-1209 grants.go:67-101; fork fbembed embed.go.
