---
id: 820ea0eb566f
kind: feature
title: 'S10 Public-facing apps are configuration-only for non-owners: shaped.json public marker, refused at parse time'
seq: 320
status: todo
priority: p1
labels:
    - software-shaping
    - boundary
created: 2026-11-15T03:07:47.261559Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
---

Operator rule 2026-11-14, recorded in umbrella docs/sprint-641-feature-matrix.md ('The public-facing rule'): on a public-facing surface, a principal who is not the owner or a named maintainer may change DECLARED CONFIGURATION ONLY. Content contributions go through a moderated path; code stays owner/maintainer-only through the ordinary candidate->verify->approve->release path; a wish beyond configuration becomes a request, never a dead end.

Scope, small and fail-closed: shaped.json gains a 'public' marker; appserver.Parse REFUSES a manifest that grants any non-owner level the mode 'shape' on a public app (beside the existing refusals for unknown keys and bad positions), so the misconfiguration is caught in review when the manifest is edited, not in production when a visitor wishes; the wish intake treats a non-owner on a public app as personalize-or-request regardless of what any level says; the refusal names the rule and the app.

Depends on S6 (levels) for the level vocabulary; pairs with Sprint 641 M4 (the feature list) for which sections are configurable.

Acceptance: a manifest marking the app public and granting members 'shape' is refused at parse with a message naming the rule; a public app's non-owner wish that would touch code is recorded as a request and builds nothing; the owner's own path is unchanged; a non-public app is unaffected; --json parity. Review question to carry into every public app: has it declared enough properties to make the invitation honest?
