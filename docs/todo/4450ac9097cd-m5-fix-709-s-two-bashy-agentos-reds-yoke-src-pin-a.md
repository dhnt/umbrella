---
id: 4450ac9097cd
kind: bug
title: 'M5 fix 709''s two bashy agentos reds: yoke src pin and the mcp skill golden'
seq: 738
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-25T05:27:42.730557Z
sprint: 709
sprint_id: b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2
sprint_title: 'Member pull/push: a granted member shapes the owner''s app from their own machine'
---

Reported by the Sprint 710 conductor in umbrella todo 60d43cb7 (red at bashy c450753f and after the 710 bump at 3535205f). Two of its three reds are 709's; the third (TestCommonOptionsVocabularyReport, from 697's fetch --user-agent) stays on 60d43cb7.

Root cause (conductor, 2026-11-24, by code inspection + history):
1. TestSrcPinsMatchLinkedModules: bashy internal/agentos/src_mount.go srcModulePins["yoke"] = 4ee516f5 (set by M2 1b3d428e), while go.mod pins yoke 39aef5bc. M1 (bashy 30fe0121) moved go.mod's yoke pin to ac3d3841 without updating src_mount.go; e16cbb29 and the 710 bump carried the mismatch. Green before 709 (both 2615421d at 8ae6dddf).
2. TestSkillHelpGoldens/mcp: M1 added the `bashy mcp connect` lines to mcpUsage (internal/agentos/mcp.go) without regenerating internal/agentos/testdata/skillhelp/mcp.skill.
Why it escaped: M1's gate ran `-run MCP` focused tests only; the conductor's review did not run the package. Same pair was fixed once before (a4dca0c2, Sprint 691).
Class: test-data defect from a product change (product correct; fixtures stale).

Fix (minimal, no product behavior change): set srcModulePins["yoke"] to the full SHA of the yoke version in bashy go.mod (39aef5bcf43f…); regenerate mcp.skill through the test's own update path (or edit to the exact rendered output). Nothing else.
Acceptance (gate host, GOWORK=off, committed pins): `go test ./internal/agentos -run 'TestSrcPinsMatchLinkedModules|TestSkillHelpGoldens|MCP'` green; record the verify command + result. Rebase on bashy origin main (3535205f or newer). Commit trailers Sprint/Story/Story-ID + `Agent: <assignee>`. Push nothing; the conductor merges.
