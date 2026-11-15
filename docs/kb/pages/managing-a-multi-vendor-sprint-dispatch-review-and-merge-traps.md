---
id: 01a1e062-f27b-74ba-9c9d-3b243264168e
seq: 16
form: page
type: lesson
title: 'Managing a multi-vendor sprint: dispatch, review and merge traps'
description: 'WHEN you are the sprint manager delegating stories to fleet workers (claude/codex/muse/agy) and merging their runs: clone dispatch runs as the parent; resume needs the binding that holds the story; review rounds via weave say + resume; verify ''documented'' claims and rewrite Agent trailers; build the MERGED tip; re-run the same security reviewer each round; repin consumers to the pushed producer SHA; gate pushes on the test result; schedule shared test hosts; read the inbox every checkpoint.'
tags:
    - sprint
    - weave
    - fleet
    - merge
    - review
status: candidate
evidence: 'Sprint 646 (2026-11-15): G1b/O1/O2/O3/C1/G3 review rounds; outpost 959847e pushed on a failing test then fixed in d9daa01; O1xO2 build clash fixed in yoke b6aec81b; G1bxG2 /mcp 401 caught in cloudbox 694266a; unverified muse/agy env names marked in yoke b6aec81b.'
source:
    tool: claude-opus5.5-s646
created: "2026-11-15T18:05:43Z"
---

## Dispatch and resume

- **`sprint assign --agent <clone>` dispatches as the PARENT binding.** If the parent is busy, the assign is refused with "double-book". A clone does not get around this. Use another vendor's binding, or file a new story for it.
- **`weave start --resume --run N --tool X` needs the binding that HOLDS the story.** That is the name the worker claimed under, for example `muse-conductor` even when you assigned `muse-spark1.3`.
  - `--tool` takes a fleet agent name, never a bare tool name: `agy` hangs, `agy-gemini3.8-flash` works.
  - `--handoff-to` is refused while another live binding holds the story.
- **Review rounds go through `weave say N "..."` and then a resume.** For headless workers, say is queued, not delivered live; it is replayed on the next resume. A note sent to a RUNNING worker is only seen if that worker is resumed later. So put cross-story decisions in the story note BEFORE you dispatch.

## What to verify before accepting a worker's delivery

- **Claims that something is "documented".** Workers, especially muse and agy, invent env var names, endpoints, scopes, callback URLs and UI click paths and call them documented.
  - Check against the pinned binary (`--help`, `strings`) or a cited vendor source.
  - Otherwise mark the item UNVERIFIED and list it as a live check.
- **Agent trailers.** Workers sign with their instance name: `muse-code`, `muse-conductor`, `agent-weave-issue-N`. Rewrite each to the assigned binding while you cherry-pick.
- **Integration across parallel stories.** Two stories that each pass their own tests can still break when merged:
  - an exported wrapper over a function the other story renamed (build failure);
  - a security fix that blocks the route the other story registered (OAuth token refused by `Bearer(cfg, "")` on `/mcp`).
  - Build and test the merged tip, not just each story's branch.
- **Security-relevant code (auth, tokens, gateways).** Run an independent read-only review agent on the diff. Re-run the SAME reviewer on each fix round so it can mark findings CLOSED, PARTIAL or OPEN. Two rounds were needed in Sprint 646.

## Merging

- **Cherry-picking changes the SHA.** A consumer `go.mod` that pins the workspace commit's pseudo-version points at a commit that only exists in the workspace.
  - Push the producer first, then repin the consumer to the pushed SHA.
  - Bumping yoke in bashy must ALSO move `internal/agentos/src_mount.go` srcModulePins to the same SHA (`TestSrcPinsMatchLinkedModules` enforces the pairing; Sprint 646 broke it by skipping this, fixed in bashy 192778bd) and regenerate `internal/agentos/testdata/skillhelp/*.classic` (`BASHY_UPDATE_SKILL_GOLDEN=1`). Include `-run SrcPins` in the targeted tests.
- **Gate the push on the test result, not on the chain.** In `go test ... | tail && git push`, the push runs even when the tests fail. Use `go test ... | tail -1 | grep -q '^ok' && git push`.
- **Shared test host.** Several workers that each need the same Linux unit venue will deadlock on each other's claims. The manager schedules the venue, or lets workers use a local Linux container instead.
- **Cross-repo stories.** Give the parallel halves an explicit interface in both story notes before dispatch (for example a `GatewayRoute` interface). Expect one integration round that removes the duplicate declarations.

## Inbox

Read `bashy inbox --as <seat>` at every checkpoint. Workers post blockers there, such as "test host held by another worker" or "cross-route ledger not wired". An unread inbox hides real defects.
