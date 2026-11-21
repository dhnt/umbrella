---
id: 9c585822cc31
kind: feature
title: 'G4 group-shape skill-script: one acceptance run per app with distinct identities, a human with an agent and an agent member'
seq: 579
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:42:54.996074Z
---

One Bash# skill-script, parameterized by app and item, composing the small --json verbs: owner creates the item and invites an editor, a viewer and an agent member; editor makes an allowed change; viewer sees it and is refused a write; an outsider with the forwarded link is refused; a member invites another circle member and is capped at their own role; the owner removes the editor, whose open session loses write then read; reconnect and reopen show the latest revision; history lists every revision with author; every page action used has its CLI verb with the same JSON. One participant acts as a human with an agent (bashy delegate or genie under the member's identity), one is a registered agent member. Runs on the fleet-mirror venue with several fake accounts, never the dev box. Rod, not fish: the script is itself shapeable. Contract: G1, docs/plan-group-participation.md.
