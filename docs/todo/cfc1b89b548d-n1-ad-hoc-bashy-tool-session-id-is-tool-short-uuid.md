---
id: cfc1b89b548d
kind: task
title: N1 ad hoc bashy <tool> session id is <tool>-<short uuid>, never reused
seq: 859
status: done
created: 2026-11-28T08:50:20.337903Z
assignee: claude-fable5.2
sprint: 744
sprint_id: 934a9e36-eb10-5022-83ec-d60e76999c11
sprint_title: Unique session ids for ad hoc bashy <tool> launches
closed: 2026-11-28T11:02:02.483702Z
closed_by: claude-fable5.2
---

Problem: bashy claude claims the id claude (the tool name) and the id is reused by the next launch, so peers cannot tell which claude is meant and a late inbox message reaches a later session.
Behavior: an unnamed launch (tool shortcut, chat -i --agent tool[:model]) mints its instance UUID first and takes the id <base>-<first 8 hex of that UUID>; the fleet instance opens with the same UUID. A live collision mints again. Named catalog agents keep their exact id and the +N scheme. --attach on an unnamed launch resolves the live session by base name (unique prefix). agentID and Launch.Nick are unchanged. bashy tool shortcut help/explain/dry-run text describes the new id.
Not in MVP: word aliases, a --name override, a TOOL column in chat sessions.
Code inspected: yoke pkg/chat/interact.go (Interact, joinNextInstance, openInteractiveInstance), pkg/chat/sessions.go (agentID), pkg/room/room.go (AgentClaimID, Find), pkg/fleet/instance.go (Open, OpenOptions); bashy internal/agentos/toolshortcut.go and custom/internal/toolshortcut.
Verification: go test yoke ./pkg/chat ./pkg/room ./pkg/fleet ./pkg/meet ./pkg/principal; bashy ./internal/agentos ./custom/internal/toolshortcut (GOWORK=off).

## Delivery (2026-11-28)

- yoke `6231227f` (main): an unnamed interactive launch mints its instance UUID
  first and joins the room as `<base>-<first 8 hex>`; `fleet.OpenOptions.UUID`
  opens the instance with that UUID; `--attach` on an unnamed launch finds the
  live session by base name and refuses when several are live. Named agents are
  unchanged.
- bashy `26843a45` (main): shortcut `--help`, `--explain` and `--dry-run` text;
  yoke pin in the root, custom, optional, toolchain and yoke modules and the
  src mount pin.
- Decision change from the plan: the suffix is the first group of the instance
  UUID (operator: "derived from uuid"), 8 hex instead of 4 random hex. With 8
  hex a repeat is not a practical concern, so the "id was used before" file
  check was dropped; a live collision still mints again.
- Evidence, fresh runs on the Windows test host (WSL lane), `GOWORK=off`:
  yoke at the delivered tree: `go test ./pkg/fleet ./pkg/room ./pkg/chat
  ./pkg/meet ./pkg/principal`, all ok. bashy at the delivered pins:
  `go test ./internal/agentos -run` the six shortcut unit tests
  (SessionID, AgentName, ParseArgs, Help, DryRun, DispatchHelp), all pass;
  `go vet ./internal/toolshortcut` in the custom module, ok.
- Not run: `TestToolShortcutE2E` (it builds bashy into an empty module cache;
  one attempt failed on the venue, a forced direct module fetch, before
  reaching the test body) and a by-hand two-session launch. Both belong to the
  next integrated run.
- Not in MVP, unchanged: word aliases, a `--name` override, a TOOL column in
  `chat sessions`.
- Pre-existing drift left alone: bashsharp, outpost and ycode pin an older
  yoke (stale before this story); the story did not touch them.
