---
id: 94c3aa2293c4
kind: feature
title: 'H1b hosted runner executes an approved gated call: the signed identity carries the settled approval (approval_id, digest, effects); the runner allows exactly those effects for that one call'
seq: 706
status: assigned
priority: p1
created: 2026-11-24T14:36:58.449177Z
weave: 237
assignee: claude-fable5.2
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Gap found reviewing H3 (2026-11-24): with no owning host the caller settles a gated call on the master, but H1's runner only has the static --allow set, so an approved destroy/spend/cred/priv call can never run hosted. Add an optional approval object to the signed per-call identity (approval_id, digest of the exact call, effects); the runner verifies the digest matches the call it is asked to run and widens the allow set for that call only; a digest mismatch answers gated, fail closed. Tests: approved call runs once; digest mismatch refused; approval cannot be replayed (same idempotency rules). Small, bashy internal/agentos/mcp_hosted.go. The wire is documented by H3. Planned vendor: claude. Spec: docs/sprint-691-master-execution-plan.md
