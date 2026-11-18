---
id: 29d1570f935c
kind: feature
title: 'S15 yoke coopauth: read and verify outpost''s relationship stamp (v2)'
seq: 481
status: todo
priority: p2
labels:
    - shaping
    - yoke
created: 2026-11-18T21:09:24.806046Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enabled simple site: showcase MVP on the operator''s résumé site'
---

Planned vendor: codex. Outpost c4e1154 (internal/agent/apps.go relationshipPayload, docs/cooperative-web-apps.md section 'The caller's relationship to the host owner') now stamps X-Outpost-Relationship (owner|member|signed-in), X-Outpost-Circle, X-Outpost-Groups, X-Outpost-Visitor and X-Outpost-Relationship-Sig = HMAC-SHA256(secret, 'v2\n'+rel+'\n'+circle+'\n'+groups+'\n'+visitor+'\n'+Remote-User+'\n'+X-Forwarded-Prefix+'\n'+X-Outpost-Identity-Ts). Task: in yoke/pkg/coopauth add header constants, a Relationship type {Kind, Circle, Groups []string, Visitor}, and VerifyRelationship(r, secret) (Relationship, bool) with the same 60 s skew as VerifyOutpost; unsigned, stale or forged returns false. Do not change VerifyOutpost or Identity semantics. Tests in pkg/coopauth: member, owner, signed-in pseudonym, forged circle, stale ts, empty secret. Accept: GOWORK=off go test ./pkg/coopauth green. COMMIT RULES: work only in the files named here; separate commit in the named subproject on its default branch with trailers Sprint: #615 / Story: #<this seq> / Story-ID: <this id> (plus your Agent trailer); never touch other stories' files, never git add -A, never push the umbrella, never bump pins (the conductor does). Targeted unit tests only (GOWORK=off go test for the touched package); no full suites, no containers or VMs on this machine. Public repo: no hostnames, IPs, home paths or real emails; use example.com. Spec: docs/sprint-615-master-execution-plan.md.
