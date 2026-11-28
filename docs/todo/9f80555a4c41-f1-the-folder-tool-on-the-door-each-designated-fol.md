---
id: 9f80555a4c41
kind: feature
title: 'F1 the folder tool on the door: each designated folder is the Tool-class offer files-NAME (typed ls/stat/read/link, os.OpenInRoot + ServeContent byte route)'
seq: 834
status: todo
priority: p1
created: 2026-11-27T15:44:28.647256Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 F1. File Browser (fbembed) is single-instance, one root, no ETag, no identity pass-through (fork embed.go:20-104): keep it as the owner's browser, unchanged. Owner vs members (operator 11-27): HOME stays owner-only via File Browser; members only see designated folders: default an empty ~/.bashy/shared/NAME/, or any other path the owner designates. Record = one JSON file per share, ~/.bashy/shared/NAME.json {name, path (missing = default folder), mode ro, audience {circles, groups, emails}, created, note, forced+reason}; no outpost unit setting. New capability outpost.shares reads ~/.bashy/shared/*.json (reload on change) and registers one app files-NAME per record (RegisterWithMetaDialer, RequireLogin, one in-memory listener, capability_support.go:150-155); per-app audience via existing outpost apps share files-NAME (no new audience code). Handler: os.OpenInRoot (no symlink/.. escape) + http.ServeContent (Range, HEAD, Last-Modified) + weak ETag from size+mtime + JSON listing for dirs; read-only. ~200-300 lines + tests. Code inspected 2026-11-27 (revised after review): outpost cmd/outpost capability_files.go capabilities.go:90-97 main.go:369 capability_support.go, internal/agent apps.go:466-486,1196-1209 grants.go:67-101; fork fbembed embed.go.

Review 2026-11-27: unchanged. A folder is data, not a tool call: it stays a gated app and its reads are not metered in this sprint (plan §3.1, §5). Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).

Revised 2026-11-27 night (operator: everything is a tool call as far as agents are concerned; the name is TaaS). A folder is a tool call too, and the door serves it, not outpost: every door request already has an authenticated principal and a run record (yoke pkg/broker broker.go:335 route switch), so gating, audit and metering come with no new mechanism and outpost needs no change. The door reads ~/.bashy/shared/*.json (reload on change); each record is the Tool-class offer files-NAME with a typed definition bashy ships (input {op: ls|stat|read|link, path, offset, length}; output listing, stat, inline bytes up to a small cap, or a bashy://HOST/files-NAME/PATH link; effects read-only; unit bytes plus the call). The tool call runs in-process; the byte route /files/NAME/PATH uses os.OpenInRoot + http.ServeContent + weak ETag + JSON listing. This story serves owner and peer: callers; member admission comes with K4 (app offer-files-NAME). The earlier 'A folder is data, not a tool call' note is superseded. Repo: yoke pkg/broker (was outpost).
