---
id: d346682b1f23
kind: doc
title: 'R3 Vocabulary sweep: docs and kb say anonymous / account / member / owner; ''user'' only for the OS user'
seq: 710
status: todo
priority: p2
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:08.574569Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Spec: docs/access-tiers.md. Update: docs/sprint-691-master-execution-plan.md tier table (tier 1 = anonymous configures declared features, nothing kept); docs/shaping-enable-a-website.md and docs/sprint-615-master-execution-plan.md (four visitor tiers -> the four relationships with account for signed-in); bashy kb/defaults/pages/shaping-enable-an-existing-website.md, set-up-outpost-install-pair-publish-apps-and-keep-a-host-private.md, run-a-class-or-meeting-on-one-page.md; bashy docs/ui-cli-parity.md; outpost/docs/cooperative-web-apps.md wording after R1. Validate the candidate kb page 'access tiers' in the umbrella kb. No code. Acceptance: rg for 'signed-in' in those docs finds only the alias note; 'user' appears only for the OS user.

## Rescoped 2026-11-24 (KISS/MVP review, operator-approved plan)

Absorbs R4 (665cf4339efd): the same commit also sets one dated Status line on plan docs 615, 638, 641, 691, 697 to match story frontmatter (615 done, S21 moved to 706; 638 superseded by 669, closed won't do 2026-11-24; 641 done; 691 ended 2026-11-24 8/8; 697 A-stories done).
