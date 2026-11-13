---
id: 82c0ddf40b66
kind: task
title: 'S2b files: port the fbembed seam to gtsteffaniak/filebrowser (Apache-2.0), multi-day'
seq: 216
status: assigned
priority: p2
created: 2026-11-13T11:41:20.525051Z
weave: 46
assignee: claude-fable5.1
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

Operator chose upstream catch-up first (S2); this port is later work. Facts 2026-11-13: Apache-2.0 LICENSE read, no ee/, 9.1k stars, active (v2.0.2-stable 2026-10-23). CGO_ENABLED=0 build passes at default tags (modernc sqlite; MuPDF via go-fitz behind -tags mupdf; cgo sqlite behind cgosql; never enable mupdf because MuPDF is AGPL). Has a token store with revocation; no command runner. Embedding cost: the global settings.Config singleton, package-level runtimeDeps in internal/web, and StartHttp owns the listener (the router is separable via configureHTTPRouter + muxWithMiddleware). All code is under internal/, so the seam must be an exported NewHandler inside the fork. Module path changes to github.com/gtsteffaniak/filebrowser/backend, so 4 consumers (outpost, yoke, bashy, ycode replaces) must move; stateless single-user mode, prefix contract, Apps header and theme must be re-done on the new Vue frontend. Estimate: multi-day.

READ docs/shapeable-apps-worker-brief.md for the sprint-wide rules (license, Linux + web UI scope, commit trailers). Base on filebrowser master c7e10f7a (final-upstream catch-up already merged); consumers: yoke pkg/webconsole, outpost files capability, bashy, ycode replaces.
