---
id: 11bbc9f6c56b
kind: feature
title: S9 Share a suite of apps with a circle of members (CLI + web parity)
seq: 107
status: todo
priority: p1
labels:
    - collaboration-mvp
    - parity
created: 2026-11-11T03:19:34.906929Z
sprint: 614
sprint_id: b3f5559a-e4b3-5d6a-9e1a-bdd0c3e7afd3
sprint_title: 'Collaboration MVP: consistent app references, KB catalog, and Memos/Calendar discovery'
---

Depends on S10 (219450271297): circles are owner-defined names, so a suite can be shared with a named circle such as `s587-class`.

Grant rule (reuse, do not reinvent): an app or suite share grants to an email or a circle with exactly the semantics of yoke pkg/boundary Allowed (active, mutual member whose email or current circle matches), the rule `llm peer --circle` already enforces. Suite expansion: sharing a suite materializes per-app circle share rows (source suite) that are rebuilt-and-replaced whenever the suite or grant changes, following the scopedpairing.Sync pattern; the access check only gains the circle match.


Operator requirement 2026-11-11: an owner groups account members into circles (exists) and groups apps into a suite, then shares one suite with one circle instead of granting each app to each member. Bashy CLI and the cloudbox web UI both support it with identical entities, permissions and approval rules.

Existing, reused (verified 2026-11-11): circles via `bashy member invite|set|ls --circle`; `llm share --email/--circle` member binding; per-app host shares `outpost apps share APP --email E` over the public wire `POST /api/v1/hosts/{host}/shares {app,email}`. Missing: a suite entity, a circle share target for apps, and suite share grants.

KISS model: a suite is an owner-account-level named set of host/app references (`suite:<slug>`, existing kind:id conventions; an app may be in several suites). A share grant is subject (app | suite) x audience (email | circle). Access is evaluated live at request time: adding an app to a suite or a member to a circle grants access with no re-share; removing either revokes it. Existing per-app email shares keep working unchanged. Only the owner manages suites and grants; members cannot.

CLI (agent-first, `--json`, `--dry-run` on writes, owner credential): `bashy suite create|ls|show|rm`, `bashy suite add|remove SUITE HOST/APP`, `bashy suite share|unshare SUITE --circle C | --email E`, `bashy suite shares`; and `outpost apps share APP --circle C` for the single-app case. Inviting is the existing `bashy member invite EMAIL --circle C`: a newly accepted member of the circle gains the circle's suites. Add rows to docs/ui-cli-parity.md for every new web action.

Wire: extend the public share contract with a circle audience and add a suite resource; document it as public wire protocol only. Server storage, enforcement and the web UI (Apps page: group apps into a suite; share dialog picks a circle) are tracked in the cloudbox repository as todo c4426d52c628.

Done when: on a satellite with two circles, a member in the shared circle gets 200 on every app of the suite; a member outside it gets 403; no credential gets 401; removing the member from the circle or the app from the suite flips to 403, and adding an app to the suite flips to 200 without a new share; a member cannot create or change suites or grants; browser and CLI show the same suites, grants and results (S6 journey covers it). Deferred: nested suites, per-app roles beyond reach, cross-owner suites, expiry.
