---
id: 8f29432f43ab
kind: feature
title: 'kb/shape/skills: add prune, compact, and tidy lifecycle actions for bashy kb and Software Shaping'
seq: 45
status: todo
priority: p1
labels:
    - kb
    - shape
created: 2026-11-08T01:01:08.283687Z
sprint: 590
sprint_id: e87405cd-e28f-57b5-bc3a-7727d4c92438
sprint_title: Third-party agent turn error-recovery OTel spans, Bash# KB wiki auto-composition, and KB/shaping tidy
---

In yoke/pkg/kb/tidy.go, yoke/pkg/shape/tidy.go, yoke/pkg/shape/slot, yoke/pkg/shape/evidence, and yoke/pkg/skills/bashsharp.go: 1) Add bashy kb {prune,compact,tidy} (--dry-run, --older-than, --tag, --json) to tombstone/archive stale unopened auto-composed candidates, merge near-duplicate candidates via kblife.Supersede, cap inline ## Editions lists (full history in journal.jsonl and .git), and compact redundant journal observe entries. 2) Add Software Shaping prune/compact/tidy actions to reclaim unreferenced side-slot binaries under shape-host/<app>/artifacts/<digest> (preserving Release, Active, Previous), prune stale/superseded .evidence records under src/.evidence, and compact unverified/superseded Bash# skill overlays (bashsharp/*.bsh) and attestation logs (attest/*.jsonl). See docs/agent-turn-recovery-and-bashsharp-kb-plan.md.
