---
id: c68cc7fee4df
kind: feature
title: 'S6 circle-protected mounts: per-mount cloudbox grant rules {mode, circles[], groups[], emails[]} evaluated by trove from the caller''s stamped relationship; trove share|who; anonymous flag'
seq: 295
status: wontfix
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:53.19821Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
closed: 2026-11-24T18:21:09.554153Z
---

Planned vendor: codex. Example level. Depends on S13 (outpost stamps the caller's relationship) and S14 (outpost apps share rule form). ONE rule grammar across the family: a mount carries rules {mode: read|write, circles[], groups[], emails[]} with cloudbox semantics (circles AND (group OR email); any rule admits; no rule = owner only; owner always passes; only active mutual members match). Circles are owner-defined slugs (defaults family/friend/team/guest, 'public' and 'owner' reserved); never hardcode names; the picker lists the circles and groups in use from the member list. Caller relationship (email, circle relative to the host owner, groups, is-owner) comes from the stamped identity on the web (S13 headers via coopauth.Identity) and from the on-host lookup on the CLI (--principal + outpost grants lookup, S13); resolved live at read time, never frozen on entries; a member is never shown the label the owner gave them. App-level admission stays with the cloudbox edge and outpost (share the trove app like any app); mount-level rules are evaluated by trove (apps interpret relationship data). Public showcase = an explicit per-mount anonymous:true flag, never a circle. trove share MOUNT --mode read|write --circle C --group G --email E (repeatable, one rule per call) and trove who MOUNT mirror the console share dialog and apps/:app/who; denied = the same not-found result on CLI and HTTP. INVARIANT (operator 2026-11-14): the circle is the HARD boundary. Groups and emails narrow access within a circle, never widen it across one; a member in a listed group but outside every listed circle is refused; family content is never reachable from company and vice versa. The wire's empty circles list is the SPECIAL circle 'every member' (opposite pole of owner-only); bashy spells it explicitly: circles: ['*'] / trove share --circle '*' (shown as 'every circle (all members)' in who and the picker; '*' is not a valid slug so it cannot collide; translated to the empty list on the wire); a rule that names no circle is refused as ambiguous at share and at load. Ladder: no rule (owner only) -> named circles -> '*' (every mutual member) -> anonymous:true (no sign-in). Family-wide follow-up outside this sprint: the same explicit '*' spelling for bashy share add / suite share. anonymous:true is the only way past every circle. Per-entry rules stay out of the product (T2 shapes one if needed). Alternatives considered and rejected in the design doc: one outpost app per mount (edge-only), per-resource grants in cloudbox, trove reading /api/v1/members itself for the web path. Rod, not fish: small --json verbs with meaningful exit codes; any higher flow is a short Bash# skill-script composing them, itself shapeable. Accept: matrix owner / member-in-circle / member-in-group / member-by-email / member-not-matching / member-in-listed-group-but-wrong-circle (DENIED) / anonymous x read, write on CLI and HTTP with identical results; --circle '*' admits every active mutual member and is sent as the empty list; a rule naming no circle is refused as ambiguous at share and at load; a circle rename on the member list changes access on the next request; refusals name mount and rule; the picker shows owner-defined circles; --json parity. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The account tier (accounts without an outpost) is served by Sprint 691 H6/H6b, the trove as the virtual drive. Retired, not delivered.
