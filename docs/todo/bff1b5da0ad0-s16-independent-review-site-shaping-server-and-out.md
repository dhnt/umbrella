---
id: bff1b5da0ad0
kind: test
title: 'S16 independent review: site-shaping server and outpost relationship stamp'
seq: 482
status: todo
priority: p1
labels:
    - shaping
    - security
    - review
created: 2026-11-18T21:09:24.981709Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enabled simple site: showcase MVP on the operator''s résumé site'
---

Planned vendor: agy. READ-ONLY review, no code changes. Review bashy/examples/shaping/website/template/*.go and public/shaping.js plus outpost internal/agent/apps.go and grants.go (commit c4e1154) for: identity spoofing (unsigned or forged headers granting a tier); a non-member's email reaching the app or its logs; audience bypass (a group widening across circles; an empty audience leaking); private data in model prompts beyond the caller's tier; XSS in shaping.js (it must use DOM nodes only); open redirect or SSRF through the proxy (upstream path handling); cache poisoning across tiers (the proxy cache keys on path only: confirm per-tier data is never cached). Write findings as a comment on this story via: bashy todo edit <id> --note with severity, file:line and a concrete failure scenario for each; 'none found' is a valid result. Run GOWORK=off go -C bashy/examples/shaping/website/template test ./... to confirm green. COMMIT RULES: work only in the files named here; separate commit in the named subproject on its default branch with trailers Sprint: #615 / Story: #<this seq> / Story-ID: <this id> (plus your Agent trailer); never touch other stories' files, never git add -A, never push the umbrella, never bump pins (the conductor does). Targeted unit tests only (GOWORK=off go test for the touched package); no full suites, no containers or VMs on this machine. Public repo: no hostnames, IPs, home paths or real emails; use example.com. Spec: docs/sprint-615-master-execution-plan.md.
