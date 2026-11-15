---
id: c68cc7fee4df
kind: feature
title: 'S6 circle-protected mounts: per-mount cloudbox grant rules {mode, circles[], groups[], emails[]} evaluated by trove from the caller''s stamped relationship; trove share|who; anonymous flag'
seq: 295
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:53.19821Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Planned vendor: codex. Example level. Depends on S13 (outpost stamps the caller's relationship) and S14 (outpost apps share rule form). ONE rule grammar across the family: a mount carries rules {mode: read|write, circles[], groups[], emails[]} with cloudbox semantics (circles AND (group OR email); any rule admits; no rule = owner only; owner always passes; only active mutual members match). Circles are owner-defined slugs (defaults family/friend/team/guest, 'public' and 'owner' reserved); never hardcode names; the picker lists the circles and groups in use from the member list. Caller relationship (email, circle relative to the host owner, groups, is-owner) comes from the stamped identity on the web (S13 headers via coopauth.Identity) and from the on-host lookup on the CLI (--principal + outpost grants lookup, S13); resolved live at read time, never frozen on entries; a member is never shown the label the owner gave them. App-level admission stays with the cloudbox edge and outpost (share the trove app like any app); mount-level rules are evaluated by trove (apps interpret relationship data). Public showcase = an explicit per-mount anonymous:true flag, never a circle. trove share MOUNT --mode read|write --circle C --group G --email E (repeatable, one rule per call) and trove who MOUNT mirror the console share dialog and apps/:app/who; denied = the same not-found result on CLI and HTTP. Per-entry rules stay out of the product (T2 shapes one if needed). Alternatives considered and rejected in the design doc: one outpost app per mount (edge-only), per-resource grants in cloudbox, trove reading /api/v1/members itself for the web path. Rod, not fish: small --json verbs with meaningful exit codes; any higher flow is a short Bash# skill-script composing them, itself shapeable. Accept: matrix owner / member-in-circle / member-in-group / member-by-email / member-not-matching / anonymous x read, write on CLI and HTTP with identical results; a circle rename on the member list changes access on the next request; refusals name mount and rule; the picker shows owner-defined circles; --json parity. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md
