---
id: 6149c764499d
kind: feature
title: 'P1 Door: self-service switch and POST /v1/peer/self'
seq: 373
status: done
priority: p1
created: 2026-11-16T03:22:38.421423Z
assignee: claude-opus5.5-s648
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
closed: 2026-11-16T05:13:26.115213Z
closed_by: claude-opus5.5-s648
---

MVP rescope 2026-11-15. Depends on the S1 spike (48f0c35e9f05). Owner switch: bashy llm self-service on|off|status --circle C (repeatable), off by default, owner-only. No caps of its own; the owner uses llm peer limit afterwards if wanted. Endpoint POST /v1/peer/self: verify identity with pkg/coopauth; check active mutual membership in an allowed circle with MemberAuthorizer; mint or rotate peer self-<email> with MintPeerCredentialFor bound to email+circle (share allow only when new); return the key once; log only the principal. Code changes: widen the peer-name check to accept @ and long emails; add a lock around peers-file saves. Refusals: one line each for not signed in, pending invitation, not a member / wrong circle, self-service off. Revoke stays for leaked keys only; a member may re-mint; removal from the circle is the cut-off. Removal takes effect via the existing per-request membership recheck. Exit: focused unit tests pass.
