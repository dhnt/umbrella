---
id: 7c7b5501492f
kind: test
title: 'J6 Desktop journey e2e: the five checks, home menu and pool-down as an automated scenario that gates every cloudbox release'
seq: 317
status: done
priority: p1
labels:
    - software-shaping
created: 2026-11-15T02:58:09.1208Z
assignee: claude-opus5.5-s641
sprint: 670
sprint_id: 4b474d28-ab40-5a06-8d82-f14e76759a4a
sprint_title: Desktop journey e2e regression gate, then ship v0.18.78 navigation
closed: 2026-11-19T17:52:40.292562Z
closed_by: claude-opus5.5-s641
---

The MVP's acceptance, recorded once with ids and screenshots where they help.

The walk: arrive at dhnt.io not signed in and see the Shape badge and the taste; sign in with OAuth2 (email identity is required before any real shape); land on the desktop; change the look and the tile order by hand; ask for a change in words and get it; ask for something outside the schema and be refused in the schema's terms; undo; see the allowance decrement; reload and find the change still there; check that a second account's desktop is untouched; then see the rung-2 invitation appear — and only then.

Acceptance: every step recorded with the revision numbers and the refusal texts; a second account proves per-person isolation; the pool-down path exercised once by disabling the route, showing settings still work; no step needed a machine, an install or a repository from the person.

## Carry-over (2026-11-19)

Sprint 641 was ended by the operator. This story is unlinked from it and stays open as a follow-up. State at carry-over:
- Evidence so far: the operator walked the journey live on dhnt.io (v0.18.77) on 2026-11-19 — sign-in, hand changes, wishes applied, a refused wish in the red alert, undo, suggest-to-owner, and the rung-2 invitation shown and answered. Journey events confirmed via `GET /api/v1/desktop/journey`.
- Remaining for acceptance: one written record with revision numbers and refusal texts, the second-account isolation check, and the pool-down path (route disabled, settings still work), preferably on a satellite rather than the master.

## Rescoped (operator, 2026-11-19): an automated e2e test and regression gate

The operator asked for the journey checks to become automated tests, so that later changes cannot silently break them. J6 is now delivered as a test, not a one-time recording. Sprint 670.

1. **Scenario.** Add a `desktop-journey` scenario to the existing hosted-control-plane e2e harness (the multi-satellite federation fixture: a real master and satellite with fake accounts). Two members in a mutual circle, plus one outsider. A canned local OpenAI-compatible model stub is the default, so runs are free and deterministic. An opt-in flag uses the real wish route.
   Steps, each asserted:
   (1) a hand change and a wish apply, each as a new revision;
   (2) a no-op wish is refused with "nothing changed";
   (3) an impossible wish is refused with `not_grantable`;
   (4) undo steps back;
   (5) the rung-2 invitation appears only after shape and undo, and a dismissal sticks;
   (6) a circle member's suggestion is stored, the owner sees the count, and the outsider gets 403;
   (7) a second account's desktop is untouched;
   (8) with the route disabled, settings still work and the wish box says why.
   API steps go through `bashy desktop ... --json`, the agentic path.
2. **Browser assertions.** A short real-browser step (dev-login cookie, `bashy browser` probe mode) asserts what a person sees: the red "Wish not granted" alert; the separate suggest card, member only; the invitation card; and the home menu and Shape-only strip from 3fea91f32387.
3. **Regression guard.** Route the desktop and UI code paths to the scenario in the harness's affected-paths table. That covers the desktop package, the desktop handlers, API and routes, the desktop-settings UI and the layout components.
4. **Release gate.** The hosted control plane's release procedure runs the affected scenarios (E2E_AFFECTED from the last release tag) and blocks on any failure. Record that in its release-packet template and its agent docs.
5. Run it on the test host by role, under narrow WSL resource claims, and keep the evidence.

Done when: the scenario passes on the test host; deliberately breaking one check, for example hiding the suggest card, makes it fail; the affected-paths table selects it for a desktop or UI change and skips it for an unrelated one; and the release procedure documents the gate.
