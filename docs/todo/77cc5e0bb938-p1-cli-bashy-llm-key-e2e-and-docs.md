---
id: 77cc5e0bb938
kind: feature
title: 'P1 CLI: bashy llm key, e2e and docs'
seq: 374
status: assigned
priority: p1
created: 2026-11-16T03:22:38.585617Z
assignee: claude-opus5.5-s648
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
---

MVP rescope 2026-11-15. Depends on the door endpoint (6149c764499d). bashy llm key --satellite NAME [--env]: calls the mint route with the signed-in Cloudbox session (no credential in argv); saves the key to an owner-only file and never prints it; --env prints client settings that reference that file. e2e on a claimed self-hosted test host (never the dev box): a member mints and chats and usage shows peer:self-<email>; a non-member is refused; rerun rotates and the old key returns 401; removal from the circle blocks the next request; self-service off refuses new mints while existing keys work. Docs: one llm-reference section (owner opt-in, member login + key + client setup). Deliver per umbrella submodule workflow with Sprint/Story trailers.
