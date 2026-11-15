---
id: 928fb2c3584e
kind: feature
title: 'M4 Boundary: which schema sections each audience may change (the badge''s disclosure)'
seq: 310
status: todo
priority: p1
labels:
    - software-shaping
    - boundary
created: 2026-11-15T02:12:49.557229Z
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: dogfood dhnt.io — a member shapes the company site in their own GitHub-backed space, proven Red-Green-Refactor'
---

Operator 2026-11-14: an app needs an owner-defined FEATURE LIST, controlled by feature flags, that bounds what a member, a guest or the public may shape — the contract and invariant component of any app. The website is just the first app.

Why it is not 638 S6 again: levels say WHO and in which mode; a feature list says WHAT, in the app's own words. The two compose — a level names the audience, a feature names the thing. A refusal then reads 'the signup flow is not shapeable here', not 'public/src/checkout.tsx is denied'.

Why it is cheap: the enforcement already exists. shaped.json declares properties and pkg/shape/verify/surface.go refuses a candidate that removes or renames a declared surface element (kinds: unit, route, flag, arg, property); per-app protected paths already gate the candidate check. This story adds the owner's vocabulary over that, not a second engine.

Shape of it (to review before coding):
  shaped.json 'features': [{ id, title, covers: {paths[], units[], routes[], properties[]}, shapeable: owner|member|guest|public, flag: on|off|practice, invariant: true|false }]
  - invariant true = the covered surface may not be removed, renamed or re-routed by any candidate, the owner's included; the verifier refuses and NAMES THE FEATURE.
  - shapeable = the audience ceiling for that feature; the caller's level (638 S6) can only narrow it, never widen it.
  - flag off = the feature is not shapeable and not advertised; flag practice = shapeable by the named audience but reset is expected (M6).
  - unknown keys refused, as the manifest already refuses them; the feature list itself is a protected path for non-owners.
  - bashy shape features APP --json lists them with the caller's own verdict per feature, so a member and an agent see the same boundary the UI shows.

Acceptance: a member wish that touches an invariant feature is refused naming the feature; a guest wish on a practice feature builds; a feature with flag off is refused and absent from features --json; a candidate that renames an invariant route fails the surface check with the feature in the message; the owner cannot widen a feature past the app's declared ceiling by editing a level; parity row for every verb. Small, separate commits in yoke.

THE MATRIX IS RECORDED: docs/sprint-641-feature-matrix.md (2026-11-14) fills this story's feature list in — four audiences (public/guest, member, satellite owner, dhnt staff), four modes (personalize, shape, request, off, plus manage which is not shaping), and three surfaces, because where the source lives decides what is possible: A the showcase site (shapeable), B apps on the owner's host (shapeable, membership is manage), C the hosted periscope and cloudbox SPAs (NOT shapeable in this MVP: prebuilt bundles in the private hub binary, no per-viewer preference store, no tile-layout entity — cloudbox ticket fada4758 adds that as data, and the MVP does not wait on it). A5 the invitation flow and A6 the app's contract (units, routes, flags, args, properties) are declared invariant for guests and members, which is how 'no API contract change' becomes enforceable by the surface verifier rather than a convention. Implement the A rows first; B needs no new code.
