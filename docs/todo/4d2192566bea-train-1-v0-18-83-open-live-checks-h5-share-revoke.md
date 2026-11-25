---
id: 4d2192566bea
kind: test
title: 'Train 1 (v0.18.83) open live checks: H5 share/revoke, re-invite real mail, A5 matrix, satellite shell title (revisit with operator first)'
seq: 748
status: todo
priority: p2
labels:
    - release
    - hosted-plane
    - revisit
created: 2026-11-25T09:41:44.044784Z
sprint: 718
sprint_id: 9984cebc-ae0e-52ba-bf24-ee859733b740
sprint_title: 'Train 1 live follow-ups (revisit): H5 share/revoke + re-invite real mail with test accounts, A5 on dhnt.io, satellite shell title'
---

Carried out of Sprint 699 on 2026-11-25 (operator: 'file as one story; we will revisit'). v0.18.83 is live on the master and all three satellites; the rest of the checklist passed (docs/sprint-699-evidence.md). Open items, each needs an operator decision before work:
1. H5 live: share a host on the released master console, the member is admitted on an attached satellite before first sign-in; revoke on the console, the member is denied after the next sync. DECIDE: which owner test account and which satellite.
2. Re-invite real mail: re-invite a pending test member and confirm a real delivery in a test inbox (not only the API email_sent field); related bug e2903321 (MAILGUN_API_BASE not read from env, Sprint 715) most likely affects only fake-mail tests. DECIDE: may the test address be the operator's Gmail alias, checked through the Gmail connector.
3. A5 feel-at-home matrix on the live dhnt.io (story 4e147ad3, proposal vendor muse-wonder), minus the MCP and site-attach legs (Sprint 711). DECIDE: assign now or later.
4. Satellite static shell: a satellite's raw index HTML still carries the operator's company <title> and meta description before the app renders the sign-in page. DECIDE: fix (smallest: neutral static title/description in the shell, the app sets the satellite name) or drop.
All checks agent-run with test accounts (no HUAT).
