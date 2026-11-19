---
id: aa166f6602f6
kind: bug
title: Outpost passes the paired account into webconsole Options.Operators so remote admin through the tunnel is recognized (follow-up to yoke b7fe0439)
seq: 367
status: todo
priority: p2
created: 2026-11-15T17:32:15.401266Z
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP phase A: voice input + dhnt.io cosmetic — the free desktop you shape by asking'
---

After d871ac00b808 a cloud caller is an operator only when Options.Operators names their vouched identity; no embedder passes Operators yet, so remote administration through the outpost tunnel falls back to the on-host path (fails safe). Fix: outpost passes the paired account into Options.Operators. Done when an outpost unit test proves the paired owner is an operator through the tunnel and a sharee is not.

## Working rules (conductor, 2026-11-19)

- Deadline: land on cloudbox dev (or outpost main) before Sprint 666 reports green; the next cloudbox build (v0.18.77) ships it and closes Sprint 641. No tag, release or deploy by the worker.
- Disk and builds: the dev box was at 100% today. Run focused package tests only (the packages you touch); no full suites, no cache wipes, no module downloads you do not need. Cloudbox handlers/server/api tests are Linux-only: run them on the Windows test host WSL, claiming it by its bare registered resource name as shown by `bashy claim list` (never the host:<name> form; queue behind the holder; never force), per cloudbox docs/kb/pages/run-cloudbox-hub-unit-tests-from-a-non-linux-dev-box.md. Use `ssh -n`, print sha256 before copying files out, never kill mid-write.
- Cloudbox schema: dev is at SchemaRevision 30. If you add a table take 31, add it to BOTH export lists, and regenerate schema goldens (default and -tags cloudbox_satellite) and all 4 route goldens on Linux.
- Handler tests use TestMain's shared db.DB; never testutil.TwoUsers in internal/handlers (it swaps the global DB and breaks later tests).
- Commit trailers: Sprint #641, Story #<seq>, Story-ID, Agent = your assigned name. Root cause before any fix of a red test that was green.
