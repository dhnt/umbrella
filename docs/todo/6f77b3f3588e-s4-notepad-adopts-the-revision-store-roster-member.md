---
id: 6f77b3f3588e
kind: feature
title: S4 Notepad adopts the revision store; roster members and named guests co-edit; export a named revision
seq: 572
status: todo
priority: p2
labels:
    - group-shaping
created: 2026-11-20T21:08:47.186002Z
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

After S2. Notepad uses the kit revision store (S1) for the note body: notepad history ID, undo ID, restore ID REV, set --base-rev, export --rev N --to pdf. The group model is the one Klatch and Page already use: a roster member is admitted by the outpost-signed owner/member stamp; a guest joins by the owner's invite and gives a name or email first; an outsider is refused. To keep one copy, Page's join code (stamp check, name prompt, cookie binding, in examples/desk/page/identity.go) moves into the kit unchanged and Notepad uses it. No viewer/editor role, no merge. Author and kind (member, signed-in, anonymous) are recorded on each revision. Unit tests (httptest) with owner, member, named guest, outsider and a bad signature: stale save 409 with both revisions, undo, restore, guest without a name refused, export of a named revision; Page tests stay green. The live two-member run is Sprint 699 story I1. 5 points. Plan: docs/sprint-684-685-master-execution-plan.md.

## Worker rules

Read the sprint card and execution plan. Work in an isolated bashy checkout. Fetch touched repositories and siblings, check origin default heads, umbrella pins and bashy mod drift. The one-pin bashy/ycode cycle is expected. Record the base SHA and pass the story build and unit suite before editing. Stop and report if scope must expand.

Run builds and unit tests only in the assigned gate-host Linux lane. The manager reserves the lane and releases it after evidence. Require gate-lane check to print ok, then use gate-lane run for every command. Use the prepared bin directory under the lane root. Test each desk module from its directory with GOWORK=off. Use an isolated story directory. No integration or end-to-end runs.

For a formerly green test failure, stop and report names, commit and venue for investigation. Compare with last green, bisect and record product, test or venue cause on the story before a repair assignment. Keep every existing test enabled. Fetch and rebase before submitting. Preserve the candidate and redo against fresh heads if the rebase is nontrivial. Re-run the story suite on the submitted SHA. Supply branch, commit, commands, counts and exits, baseline and candidate evidence. Include Sprint, Story, Story-ID and Agent trailers. The manager owns merges, tags, proxy publication, pin updates and pushes. Use host roles in all public evidence.

Publish kit v0.3.0 and chart v0.1.2 via the local module proxy. Update register-modules.sh, repin the eight kit consumers and four chart consumers and generate their go.sum entries with Go. Build and run each consumer unit suite at the new pins. Use a private gate proxy while iterating.

For the S4 module publication, use a new private proxy, GOMODCACHE and GOCACHE under lane scratch for each candidate. Only accepted bytes may enter the shared proxy and shared caches. Publish from clean committed trees. Regenerate chart's kit checksum before publishing chart, then regenerate the other consumers' sums with Go. The manager verifies those sums against the final commit and publishes that commit to the shared proxy. Run the full kit, Page and Notepad suites and the Go unit suites of the other direct consumers. Retain test evidence for the exact candidate SHA. Claim a free gate lane only for the build and test step, and release it when done. Use the prepared SSH transport from the host KB and the full repository on the gate. If a baseline fails, report its name and cause before a fix. Send concerns and candidate evidence to the manager through the board.
