---
id: 772036cff267
kind: task
title: release cloudbox v0.18.75 (dev -> main; S641 desktop shaping + GitHub OAuth email fix)
seq: 436
status: done
priority: p1
created: 2026-11-17T20:49:44.349134Z
assignee: claude-opus5.5-s656
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-17T21:34:43.929387Z
closed_by: claude-opus5.5-s656
---

Operator greenlight 2026-11-17. Scope: cloudbox origin/dev 85595e6 (9 commits over main: desktop Shape panel/sections/undo/badge, MCP desktop gateway tools, export/import desktop tables, schema revision 28 goldens, GitHub verified-email fix for private profiles, Sprint 649 OAuth acceptance doc). DESKTOP_WISH_* stays unset (wishes disabled by design until the operator mints the llm:chat token). Verification per operator rule: build + unit tests on the gate host (Linux) + release image build + minimal production smoke; no full e2e, no paid throwaway gate instance. Deploy like v0.18.74: live App Platform spec with only the image tags changed (repo .do/app.yaml has drifted - never apply it), then satellites' upgrade target. Packet docs/releases/v0.18.75.md in cloudbox (private).
