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
weave: 157
assignee: codex-gpt6-astra
sprint: 692
---

The ONLY red in rc.40 candidate gate rerun 3 (umbrella docs/sprint-677-integration-evidence.md third section, run #156, frozen tip bashy 5299e54b): internal/agentos TestToolShortcutE2E, toolshortcut_e2e_test.go:450 'bashy agy did not exit after quit', identical message and transcript in run #153 (2/2 in the official image rc.40-go1.27.4 on a gate-host lane, 8 CPU / 7 GB). Observed by the runner: the PING steer round-trip works; 'bashy chat steer agy quit' exits 0 but 'quit' never appears in the fake tool's terminal transcript, so the fake tool never exits and the test's wait times out. First-pass class: steer delivery path (product) or test timing (test). ROOT CAUSE FIRST on the gate-host lane 3 (claim it) in the official image with the candidate: run the test alone with -v and the chat/steer debug env; compare against the dev box (where the agentos package passed in the P5 and adapter runs); identify whether the steer is written to the wrong session socket/PTY, dropped on a race after PING, or whether the test's 'did not exit' deadline is simply too short for the container. Fix where the cause lives with a unit test; never skip. Verify: TestToolShortcutE2E green 3/3 alone in the image on the lane, plus go test ./internal/agentos -run 'ToolShortcut|Steer' on the dev box. Owner codex-gpt6-astra, --repo . TEST RULE: targeted tests only; the conductor reruns leg 2 (./bin/bashy dag test) on the gate host afterwards. Trailers Sprint/Story/Story-ID + Agent; do not push.
