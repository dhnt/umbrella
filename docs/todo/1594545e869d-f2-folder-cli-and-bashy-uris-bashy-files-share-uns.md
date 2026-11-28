---
id: 1594545e869d
kind: feature
title: 'F2 folder CLI and bashy:// URIs: bashy files share/unshare/shares (owner), ls/stat/cat/get/link (member)'
seq: 835
status: done
priority: p1
created: 2026-11-27T15:44:28.894254Z
assignee: codex-gpt6.2-astra
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
closed: 2026-11-28T06:49:14.478892Z
closed_by: claude-opus5.5
---

Plan: docs/sprint-739-master-execution-plan.md §4 F2. Owner: bashy files share NAME [--path DIR] [--circle|--group|--email] [--force --reason R] writes ~/.bashy/shared/NAME.json (creates the empty default folder when no --path), then outpost apps share files-NAME; refuses a path that is HOME, an ancestor of HOME or contains ~/.bashy unless --force (logged in the record); unshare NAME (removes record, app and rule; keeps files); shares lists the records. Member: bashy files ls/stat/cat/get/link over the satellite with the member token (SatelliteTokenSource; relax ParseSatelliteAppURL satellite_exchange.go:39 for files-* apps), mesh for owned hosts; bashy://HOST/files-NAME/PATH resolution shared with K3. CLI is the agent surface; MCP wrapper only if bashy's existing MCP exposure already covers verbs. Not in MVP: write, sync, caching, locking, versioning, mounts, quotas, discovery listing. Code inspected 2026-11-27 (revised after review): yoke pkg/fleet satellite_exchange.go satellite_invite.go; bashy internal/agentos mcp_connect.go.

Review 2026-11-27: unchanged. Folder verbs are not offered tools and are not metered in this sprint (plan §3.1, §5). Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).

Revised 2026-11-27 night (operator: everything is a tool call as far as agents are concerned; the name is TaaS). Folder verbs are tool calls: bashy files share offers files-NAME with the audience (outpost apps share offer-files-NAME); member ls/stat/cat/get/link HOST:NAME/PATH is a thin CLI over the files-NAME call; an agent can instead mount it with bashy remote add HOST files-NAME (T2). Relax the satellite URL check for offer-* apps. The earlier 'not offered tools, not metered' note is superseded.

Seam (conductor, 2026-11-27; runs in parallel with F1, so code against this contract with an httptest fake door):
- New yoke package pkg/sharedfiles exporting NewCmd() (the `files` noun) and the record type Record {name, path, mode, audience {circles, groups, emails}, created, note, forced, reason} stored at <bashy-home>/shared/NAME.json (honor BASHY_HOME like pkg/fleet does; tests use a temp home). The conductor mounts NewCmd in bashy and points F1's door code at this Record at merge; do not edit pkg/broker.
- Owner: files share NAME [--path DIR] [--circle C] [--group G] [--email E] [--note T] [--force --reason R] writes the record (default folder created empty when --path is absent; refuse HOME, an ancestor of HOME, or any path inside <bashy-home> unless --force with --reason; a forced share records forced+reason); files unshare NAME removes the record, keeps the files; files shares lists records. Applying the audience to outpost is K4's job: only store it here.
- Member/agent: files ls|stat|cat|get|link HOST:NAME[/PATH] and the same with a bashy://HOST/files-NAME/PATH URI. Each is the tool call POST {door}/files/NAME with JSON body {op: ls|stat|read|link, path, offset, length}; get streams GET {door}/files/NAME/PATH to a local file (Range resume optional, not required). Resolve HOST to a door URL and credential with the existing door/peer resolution the toolcmd --peer path uses (pkg/toolcmd peer.go); the satellite member path arrives with K4.
- Add ParseSatelliteAppBase in pkg/fleet/satellite_exchange.go: like ParseSatelliteAppURL but accepts /matrix/h/HOST/app/NAME[/rest] for NAME with prefix offer-; leave ParseSatelliteAppURL unchanged.
- All verbs take --json.

Worker rules (conductor claude-opus5.5, 2026-11-27; KISS/MVP):
- Read yoke/CLAUDE.md first. Work in the yoke submodule of your workspace on branch s739-f2, based on current origin main. Change only what Accept needs; no refactors, no renames, no new dependencies.
- Tests: targeted unit tests only: `cd yoke && GOWORK=off go test ./pkg/sharedfiles/ ./pkg/fleet/ -run 'Satellite|Shared'`. No full suites, no e2e, no network, no podman.
- Commit in yoke with trailers: Sprint: #739 / Story: #835 / Story-ID: 1594545e869d / Agent: <your agent name>. Do not push main, do not bump any pin, do not edit bashy.
- Finish by appending a "Delivery" paragraph to this story file (files changed, test command and result) and commit it in the umbrella workspace with the same trailers.
- Budget about 30 minutes. If blocked, write the blocker in the story, commit, and stop.

Delivered (conductor record): yoke main 7c73cc8c (worker commit dc53129d by codex-gpt6.2-astra, cherry-picked). Gate: GOWORK=off go test ./pkg/sharedfiles/ and ./pkg/fleet -run Satellite ok; go vet ok. Peer/member admission to /files arrives with K4.
