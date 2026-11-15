---
id: 349ecc908c9b
kind: feature
title: S11 A wish beyond your privilege demotes to a request, never a bare refusal
seq: 321
status: todo
priority: p2
labels:
    - software-shaping
    - boundary
created: 2026-11-15T03:14:43.615282Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
---

Operator rule 2026-11-14, recorded in umbrella docs/sprint-641-feature-matrix.md ('Refusals demote; they never dead-end'). The same principle the message bus already enforces as DEMOTE, NEVER DROP, applied to privilege instead of delivery.

Scope: where the level or feature list refuses a wish, the engine records it as a REQUEST instead of returning a bare error — the person's own words, the page and element, who asked, and the reason it could not be built — and tells the person what happened, where it went and how to follow it. Reuses the protected-page fileRequest path and S6's request mode; the owner sees it in the queue (Sprint 640). A wish beyond the OWNER's reach (the invariant floor, the chrome laws, the wire contract) demotes to product feedback for staff, and that one needs the person's explicit consent because it leaves their plane.

Guardrails, each one testable: a demotion performs no part of the privileged action (words, never effects); the recorded text is untrusted data when an owner or agent later acts on it; requests count against the same per-person allowance even when no model was called; identical wishes aggregate rather than arriving many times; nothing leaves the person's plane without consent.

Depends on S6 (levels), pairs with Sprint 641 M4 (the feature list) and Sprint 640 (the queue that receives them).

Acceptance: a member wish on a denied path returns a request id and a message naming the feature and the destination, and builds nothing; the same wish twice aggregates; an invariant-floor wish offers consent before anything is sent to staff and sends nothing if declined; the allowance decrements; no demotion path can perform a privileged side effect (asserted by test, not by review).
