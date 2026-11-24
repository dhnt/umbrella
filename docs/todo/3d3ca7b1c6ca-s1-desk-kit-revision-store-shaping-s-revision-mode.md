---
id: 3d3ca7b1c6ca
kind: feature
title: 'S1 Desk-kit revision store: shaping''s revision model for an artifact (history, undo, restore, save against base_rev)'
seq: 578
status: done
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:42:54.820612Z
assignee: agy-gemini4-carbon
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
closed: 2026-11-24T09:18:36.153958Z
closed_by: codex-gpt6.2-astra
---

One small file, examples/desk/kit/revision.go, shaped like yoke/pkg/shape/slot/slot.go: immutable snapshots plus an active/previous pointer. Save(item, part, base_rev, author, assistant, data): a base_rev that is not the active revision is refused with both revisions; no base_rev is a recorded overwrite. Undo swaps active and previous; Restore selects any retained revision; History lists {revision, author, assistant, created} with active and previous. The app chooses the bytes and decides who may write; the store never checks roles or identity and never owns the item file (snapshots sit beside it). One shared action handler for history, undo and restore so an adopting app wires a few lines and gets the same JSON on page and CLI. The contract table (same words and JSON as bashy shape history|undo|restore) goes in the kit README. Tag the kit v0.2.0. No merge, no lock, no roles. Unit tests (GOWORK=off go test ./... in examples/desk/kit): save, stale base returns both, save without base, undo swaps, restore any, save after restore, history order, reload from disk. 3 points. Plan: docs/sprint-684-685-master-execution-plan.md.

## Worker rules

Read the sprint card and execution plan. Work in an isolated bashy checkout. Fetch touched repositories and siblings, check origin default heads, umbrella pins and bashy mod drift. The one-pin bashy/ycode cycle is expected. Record the base SHA and pass the story build and unit suite before editing. Stop and report if scope must expand.

Run builds and unit tests only in the assigned gate-host Linux lane. The manager reserves the lane and releases it after evidence. Require gate-lane check to print ok, then use gate-lane run for every command. Use the prepared bin directory under the lane root. Test each desk module from its directory with GOWORK=off. Use an isolated story directory. No integration or end-to-end runs.

For a formerly green test failure, stop and report names, commit and venue for investigation. Compare with last green, bisect and record product, test or venue cause on the story before a repair assignment. Keep every existing test enabled. Fetch and rebase before submitting. Preserve the candidate and redo against fresh heads if the rebase is nontrivial. Re-run the story suite on the submitted SHA. Supply branch, commit, commands, counts and exits, baseline and candidate evidence. Include Sprint, Story, Story-ID and Agent trailers. The manager owns merges, tags, proxy publication, pin updates and pushes. Use host roles in all public evidence.

The manager reserved gate lane 2 for this story.

Publish kit v0.2.0 and chart v0.1.1 via the local module proxy. Update the two version lines in examples/desk/register-modules.sh, repin all eight kit consumers and all four chart consumers, and generate their go.sum entries with Go. Build and run each consumer unit suite at the new pins. Use a private gate proxy for candidate builds and reserve the shared proxy for accepted bytes. The version identifiers belong to the proxy.
