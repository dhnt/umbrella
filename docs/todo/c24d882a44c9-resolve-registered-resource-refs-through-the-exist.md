---
id: c24d882a44c9
kind: bug
title: Resolve registered resource refs through the existing uniform ref contract
seq: 524
status: assigned
priority: p1
labels:
    - refs
    - resource
created: 2026-11-19T11:20:06.798836Z
weave: 95
assignee: codex-gpt6-sol
sprint: 668
sprint_id: b09e97b0-b580-5fc1-8a77-8c4377c92883
sprint_title: Uniform entity references and authorized discovery
---

The earlier uniform ref design (dhnt-docs/docs/uniform-ref-addressing.md D10-D14, commit 145e0fab) proposed UUID, scoped slug and local sequence handles for addressable entities. The operator's later design correction accepts an unambiguous full parent path, such as host UUID / sprint sequence / todo sequence; absence of a per-record UUID alone is not a defect. Audit registered Resource identity and its existing parent/sequence semantics before adopting this candidate. Reuse the shipped resolver without a parallel catalog. Add persisted standalone identity only if Resource must remain independently portable across rename/host transport and the current handles cannot meet that need. Preserve aliases, authorization, and ambiguous-input refusal. Prior audit/fix examples are closed umbrella stories 53b78fabbe9f and f5bf8d3422e7. Sprint 666 #523 is the separate physical claim-address collision fix and does not require this migration.

Preserved public candidate lane owns Yoke fleet Resource persistence and the existing shared ref/define seam for `resource` only. The separate fleet family story [[todo:5d09e99b4545]] owns agent definition, tool, model, host and skill records; conversation Instance is distinct. The existing candidate adds UUID, scoped slug and local sequence handles; its source and review findings remain archived, not endorsed. Reassess whether each added handle is necessary before integration. Resource known-handle lookup must reject ambiguous scope/name input and keep private inventory details behind existing authorization. Name and alias inputs to claim acquisition must preserve the physical claim key semantics. Review legacy records, rename and different-host collisions, and CLI/JSON round trips. Bashy internal/agentos/refs.go and authorized discovery belong to #528. Future tests and cross-platform vet run on claimed test hosts after separate authorization; no coreutils or shell source changes.

Planned Sprint 668 also carries an all-kind audit. For each kind, distinguish authorized discovery/search from resolution of an already known handle. A unique full parent path is sufficient where it already works; add independent identity only for a demonstrated gap. None of this is a Sprint 666 MVP closure gate.
