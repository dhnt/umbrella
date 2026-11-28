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


Seam (conductor): new file pkg/broker/files.go (+ files_test.go), wired into the route switch in broker.go ServeHTTP. Routes: POST /files/NAME = the tool call (JSON body {op: ls|stat|read|link, path, offset, length}, JSON result); GET /files/NAME?definition = the typed definition (a Go constant JSON schema; K2 later folds it into the generic definition); GET|HEAD /files/NAME/PATH = the bytes (os.OpenInRoot + http.ServeContent + weak ETag from size and mtime; a directory returns a JSON listing). Records: <bashy-home>/shared/NAME.json via the existing bashy-home helper (tests use a temp home); re-read per request, no watcher. A missing path means <bashy-home>/shared/NAME/. Read-only. read returns inline bytes up to 256 KiB, larger asks for link. link returns bashy://HOST/files-NAME/PATH (HOST = the door's own host name; a helper is enough). Admission in this story: the door's existing owner auth only; peer and member admission come with K4. Put the bytes served on the existing run Record (one field; T1 names the rest).
Worker rules (conductor claude-opus5.5, 2026-11-27; KISS/MVP):
- Read yoke/CLAUDE.md first. Work in the yoke submodule of your workspace on branch s739-f1, based on current origin main. Change only what this story's Accept needs; no refactors, no renames, no new dependencies.
- Tests: targeted unit tests for the packages you touch only, e.g. `cd yoke && GOWORK=off go test ./pkg/broker/ ./pkg/toolcmd/`. No full suites, no e2e, no network, no podman, no paid provider. Use fakes (httptest) for doors and agents.
- Commit in yoke with trailers: Sprint: #739 / Story: #834 / Story-ID: 9f80555a4c41 / Agent: <your agent name>. Do not push main, do not bump any pin, do not edit other repos except as the story says.
- Finish by appending a "Delivery" paragraph to this story file (files changed, test command and its result) and commit it in the umbrella workspace with the same trailers.
- Budget about 30 minutes. If blocked, write the blocker in the story, commit, and stop. Do not work around a failing pre-existing test: record it.
