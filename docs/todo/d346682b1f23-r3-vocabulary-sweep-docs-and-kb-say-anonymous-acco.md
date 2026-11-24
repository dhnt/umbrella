---
id: d346682b1f23
kind: doc
title: 'R3 Vocabulary sweep: docs and kb say anonymous / account / member / owner; ''user'' only for the OS user'
seq: 710
status: assigned
priority: p2
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:08.574569Z
weave: 244
assignee: agy-gemini4-hydrogen
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Spec: docs/access-tiers.md. Update: docs/sprint-691-master-execution-plan.md tier table (tier 1 = anonymous configures declared features, nothing kept); docs/shaping-enable-a-website.md and docs/sprint-615-master-execution-plan.md (four visitor tiers -> the four relationships with account for signed-in); bashy kb/defaults/pages/shaping-enable-an-existing-website.md, set-up-outpost-install-pair-publish-apps-and-keep-a-host-private.md, run-a-class-or-meeting-on-one-page.md; bashy docs/ui-cli-parity.md; outpost/docs/cooperative-web-apps.md wording after R1. Validate the candidate kb page 'access tiers' in the umbrella kb. No code. Acceptance: rg for 'signed-in' in those docs finds only the alias note; 'user' appears only for the OS user.

## Rescoped 2026-11-24 (KISS/MVP review, operator-approved plan)

Absorbs R4 (665cf4339efd): the same commit also sets one dated Status line on plan docs 615, 638, 641, 691, 697 to match story frontmatter (615 done, S21 moved to 706; 638 superseded by 669, closed won't do 2026-11-24; 641 done; 691 ended 2026-11-24 8/8; 697 A-stories done).

## Code inspected 2026-11-24 (before planning; facts at origin heads)

- Counts of signed-in: docs/shaping-enable-a-website.md 2 (+3 signed_in, 1 'four visitor tiers'); docs/sprint-615 plan 8; docs/sprint-691 plan 0; bashy kb/defaults/pages/shaping-enable-an-existing-website.md 3; set-up-outpost-...-private.md 1; bashy docs/ui-cli-parity.md 3; outpost/docs/cooperative-web-apps.md 4 (278, 281, 284, 305).
- Path fix: run-a-class-or-meeting-on-one-page.md is at bashy/docs/kb/pages/, not kb/defaults/pages.
- The umbrella kb page already exists: docs/kb/pages/access-tiers-anonymous-account-owner.md (indexed in docs/kb/index.md). 'four visitor tiers' also appears in docs/README.md and docs/INDEX.md.
