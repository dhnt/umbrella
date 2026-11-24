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

Delivered 2026-11-24 (claude): bashy b08c3f14 on branch agent/weave-issue-237 (not pushed; the conductor pulls). The signed identity takes an optional `approval: {approval_id, digest, effects}`; a malformed one (blank id, digest not 64 lowercase hex, empty or non-gated effects) refuses the identity. The runner computes the call digest itself and now returns it in the hosted gated answer `{state: "gated", effects, task_id, digest}`, so the master carries the digest into the approval it raises and needs no digest code of its own. Digest = hex SHA-256 over length-prefixed elements (`<len>:<bytes>;`): `bashy-hosted-call-v1`, caller, task_id, tool name, arguments name, dir, stdin, count of args, args, count of env, sorted KEY=value. An approval grants its effects to the one call whose digest matches, on a per-request grant map; the runner's `--allow` set is untouched. A digest mismatch or an approval lacking a needed effect answers gated and does not spend the identity; the approved call claims its idempotency key, so a second send answers replayed. Calls of one request run one at a time, so a JSON-RPC batch cannot borrow the approval. The wire was posted to the H3 owner on the board.

Tests (fresh, dev box, bashy b08c3f14): `go test -run TestMCP ./internal/agentos` ok; `GOWORK=off go test -run 'MCPHosted|MCPOutpost|Gateway' ./internal/agentos` ok; `go build ./...` and the windows/amd64 cross-build of cmd/bashy ok. New TestMCPHostedApproval covers: approved call runs once (audit allows rm exactly once), digest mismatch (other args, other stdin) gated, approval for other effects gated, replay refused, malformed approvals refused.

Not green, not caused by this story: the full `go test ./internal/agentos` exceeds the default 10 minute timeout on the dev box (700 s with a 40 minute limit) and fails 8 tests that fail identically with the parent commit's sources (d69d9e95): TestEmbeddedAdaptersMatchSourceTree, TestPilotCatalogDispatchE2E, TestCommonOptionsVocabularyReport, TestReleaseSbomCLI, TestReleaseSbomMatrixVerify, TestSkillHelpGoldens, TestSrcPinsMatchLinkedModules, TestToolShortcutE2E. Root cause not investigated here; they need their own todo. Gap: the hash-chained audit record has no approval field, so approval_id appears only on the stderr audit line.

Merged 2026-11-24 by the conductor: bashy c2443b89 (from b08c3f14) on top of a4dca0c2, which repairs two regressions from earlier Sprint 691 merges found while checking this story (TestSkillHelpGoldens/mcp, TestSrcPinsMatchLinkedModules). Conductor rerun: TestMCP|TestSkillHelpGoldens|TestSrcPins ok. The remaining full-package failures are pre-existing (bashy todo 221aa363). Gap kept for later: the hash-chained audit record has no approval field.
