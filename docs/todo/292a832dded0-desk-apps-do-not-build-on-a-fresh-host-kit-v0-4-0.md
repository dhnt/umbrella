---
id: 292a832dded0
kind: bug
title: 'Desk apps do not build on a fresh host: kit v0.4.0 republished with new content (checksum mismatch) and consumers pin unpublished kit v0.3.0'
seq: 750
status: assigned
priority: p0
labels:
    - release
    - desk
created: 2026-11-25T12:02:22.411752Z
assignee: claude-opus5.5
sprint: 719
sprint_id: 049a8467-4736-5eab-9ce8-52274347d7a0
sprint_title: Release bashy v1.0.0-rc.41 (thin bashy; rc.40 never promoted)
---

Found by rc.41 leg 2 (TestDeskSkillDocumentedVerbsValid, notepad --help=mcp exit 1). Reproduced in the official image on the gate host with a fresh HOME and the proxy filled by examples/desk/register-modules.sh: notepad and page fail 'verifying kit@v0.4.0: checksum mismatch / SECURITY ERROR'; form, viewer and calendar fail 'unknown revision examples/desk/kit/v0.3.0'. Root cause (product): 56b5b1a1 (Sprint 682) made kit/chart versioned modules published only to the local proxy; later kit edits (9db42aa8, 68fd9961, 7dc2fc12) moved register-modules to kit v0.4.0 but kept recording go.sum hashes from an older v0.4.0 content, and five consumers kept kit v0.3.0, which register-modules no longer publishes. No test in the root module covers the nested consumers, so dag test did not catch it until the skills test ran go run without the proxy (that part is a test defect). Fix: publish kit v0.5.0 / chart v0.1.3 from the current trees, move all eight consumers (calendar, session, brainstorm/server, desk/{chart,form,notepad,page,viewer}) and register-modules to them, regenerate go.sum against the local proxy; root-module regression test that every consumer requires exactly the register-modules versions and that their go.sum h1 equals the module hash of the current kit/chart trees; the skills test fills a temp proxy the way register.sh does.

Provenance note: bashy 54fcfae9 (the fix for this story) carries `Story: #749` by mistake; its `Story-ID: 292a832dded0` is right (seq #750). Published history is not rewritten.
