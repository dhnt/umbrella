---
id: a3e6d41e5fb7
kind: bug
title: 'TestToolShortcutE2E fails deterministically in the official image: ''bashy agy did not exit after quit'' (steer ''quit'' never reaches the fake tool''s terminal)'
seq: 632
status: assigned
priority: p0
labels:
    - bashy
    - gate
    - release
created: 2026-11-22T19:14:46.375725Z
assignee: codex-gpt6-astra
sprint: 692
---

The ONLY red in rc.40 candidate gate rerun 3 (umbrella docs/sprint-677-integration-evidence.md third section, run #156, frozen tip bashy 5299e54b): internal/agentos TestToolShortcutE2E, toolshortcut_e2e_test.go:450 'bashy agy did not exit after quit', identical message and transcript in run #153 (2/2 in the official image rc.40-go1.27.4 on a gate-host lane, 8 CPU / 7 GB). Observed by the runner: the PING steer round-trip works; 'bashy chat steer agy quit' exits 0 but 'quit' never appears in the fake tool's terminal transcript, so the fake tool never exits and the test's wait times out. First-pass class: steer delivery path (product) or test timing (test). ROOT CAUSE FIRST on the gate-host lane 3 (claim it) in the official image with the candidate: run the test alone with -v and the chat/steer debug env; compare against the dev box (where the agentos package passed in the P5 and adapter runs); identify whether the steer is written to the wrong session socket/PTY, dropped on a race after PING, or whether the test's 'did not exit' deadline is simply too short for the container. Fix where the cause lives with a unit test; never skip. Verify: TestToolShortcutE2E green 3/3 alone in the image on the lane, plus go test ./internal/agentos -run 'ToolShortcut|Steer' on the dev box. Owner codex-gpt6-astra, --repo . TEST RULE: targeted tests only; the conductor reruns leg 2 (./bin/bashy dag test) on the gate host afterwards. Trailers Sprint/Story/Story-ID + Agent; do not push.

Root cause (before fix): PRODUCT. Frozen bashy 5299e54b reproduced on gate-host lane 3 in the official rc.40 image: TestToolShortcutE2E fails after 30.72s with the same PING-only transcript. Live process inspection identifies standalone custom/agy -> standalone yoke/chat, not the in-process chat wiring. Board seq 1 PING and seq 2 quit address the identical session inbox; room timeline records PING only. The standalone relay uses bus.StoreFingerprint, which omits the message board posts.jsonl that queued steers append. PING changes the room timeline when delivered; after that sample is committed, quit is invisible until the 30s full rescan. No wrong socket/PTY, lost append, or resubmit collision; extending the exit deadline would mask delayed product delivery. Plan: add deterministic default-poll-gate regression for sequential board steers, include board metadata in the default fingerprint, verify the exact corrected dependency in the adapter on lane 3 three times and targeted agentos on the dev box. Candidate pins remain frozen for diagnosis; no unrelated drift repair or push. Debug env variables were supplied but this candidate has no chat/steer debug-env implementation; live durable queues and process inspection provide the trace. Initial cold-cache probe hit adapter build deadline and is separate from the warm-cache reproduced quit failure.

Delivery: yoke 3eb700cd39d9; bashy f1907987 pins core/adapter modules and source mount. New unit regression RED before, GREEN after (normal and race); official-image bus tests PASS. Official lane3 E2E PASS 3/3 (31.81s, 29.78s, 29.75s; package 91.385s), no skips, job exit 0. Dev ToolShortcut|Steer PASS 50.417s (E2E 48.34s). Standalone source-pin test PASS 1.686s. No deadline change. Full evidence: docs/sprint-677-integration-evidence.md Story 632. No push: producer must be published before the consumer versioned pins are resolved from a clean remote cache. Exact unpublished module verified through temporary git-archive-based local proxy; no replacements committed. Full candidate leg 2 remains conductor-owned.
