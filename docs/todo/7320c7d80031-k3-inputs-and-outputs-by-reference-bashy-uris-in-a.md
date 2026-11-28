---
id: 7320c7d80031
kind: feature
title: 'K3 inputs and outputs by reference: bashy:// URIs in, artifact URIs out; refuse host paths from peers'
seq: 831
status: done
priority: p1
created: 2026-11-27T15:34:19.372087Z
assignee: codex-gpt6-sol
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
closed: 2026-11-28T07:00:54.804119Z
closed_by: claude-opus5.5
---

Plan: docs/sprint-739-master-execution-plan.md §4 K3. Pre-existing hazard: a peer-supplied json-file or path-shaped arg is read from the door host's filesystem (fleet toolcommand.go:358-375). Refuse host paths from peer/member callers; accept bashy:// URIs, fetched into the run's scratch dir by the offerer (member token, F2). Artifacts (Result.Artifacts, output file:<glob>, print.go:276-311) move into the offerer's output share <bashy-home>/shared/offers/ (app files-offers, same audience as the offer; F1) and return as URIs with size + sha256; small text stays inline. Depends on F2. Code inspected 2026-11-27 (revised after review): yoke pkg/toolcmd toolcmd.go print.go peer.go, pkg/cligw slash.go:261-277, pkg/fleet toolcommand.go.

Review 2026-11-27: unchanged in scope. Applies to tool and agent calls alike; a model call has no file arguments. Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).

Seam (conductor, 2026-11-27; base = yoke main with K1 6efea8dc and F2 7c73cc8c):
- Principal at the run: the broker knows the caller (owner, peer:NAME, later member:EMAIL); cligw does not. Pass it with the smallest mechanism that cannot be forged: a request-context value if broker calls cligw in-process, otherwise an internal header the broker always strips from inbound requests and then sets. Owner runs keep today's behavior exactly.
- Inputs: for a non-owner principal, a path-shaped argument (ToolCommandArgJSONFile in pkg/fleet toolcommand.go:358 and any {args} value that names an existing host path) is refused with a typed 400 naming bashy:// as the fix, unless it is a bashy://HOST/files-NAME/PATH URI. A URI is fetched into the run's scratch directory before the run with an exported pkg/sharedfiles func Fetch(ctx, uri, dst) (reuse member.go's get path and toolcmd.LoadPeer credentials) and the argument is rewritten to the scratch path.
- Outputs: for a non-owner principal, Result.Artifacts (door-host paths) are copied into <bashy-home>/shared/offers/RUNID/ (create the files-offers record via sharedfiles if missing; audience empty until K4) and replaced by bashy://SELF/files-offers/RUNID/BASENAME plus size and sha256 (add ArtifactRefs []{uri,size,sha256} to Result; keep Artifacts empty for non-owners). SELF = the door's own host name from os.Hostname lowercased, behind one helper K4 can replace.
- No new CLI. Small text stays inline as today.

Worker rules (conductor claude-opus5.5, 2026-11-27; KISS/MVP):
- Read yoke/CLAUDE.md first. Work in the yoke submodule of your workspace on branch s739-k3, based on current origin main (fetch first). Change only what this story needs; no refactors, no renames, no new dependencies.
- Tests: targeted unit tests only: `cd yoke && GOWORK=off go test ./pkg/toolcmd/ ./pkg/cligw/ ./pkg/sharedfiles/ ./pkg/broker/`. No full suites, no e2e, no network, no podman. Fake doors with httptest.
- Commit in yoke with trailers: Sprint: #739 / Story: #831 / Story-ID: 7320c7d80031 / Agent: <your agent name>. Do not push main, do not bump any pin, do not edit other repos.
- Finish by appending a "Delivery" paragraph to this story file (files changed, test command and result; the story file is docs/todo/7320c7d80031-k3-inputs-and-outputs-by-reference-bashy-uris-in-a.md) and commit it in the umbrella workspace with the same trailers.
- Budget about 40 minutes. If blocked, write the blocker in the story, commit, and stop.

Delivered (conductor record): yoke main febde3ad (worker commit fb1c37bf by codex-gpt6-sol, cherry-picked). Gate: GOWORK=off go test ./pkg/broker ./pkg/cligw ./pkg/toolcmd ./pkg/sharedfiles ok, vet ok. Known MVP limit: the host-path refusal is a heuristic (an argument naming an existing door-host file is refused); mutating commands stay refused remotely.
