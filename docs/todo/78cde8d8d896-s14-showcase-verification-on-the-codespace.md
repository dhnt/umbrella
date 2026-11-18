---
id: 78cde8d8d896
kind: test
title: S14 showcase verification on the Codespace
seq: 473
status: todo
priority: p1
labels:
    - shaping
    - dogfood
created: 2026-11-18T20:35:32.666932Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enable an existing website: free host or owner outpost, guest and circle tiers'
---

Planned vendor: claude. Run verification 1-6 of the plan on a Codespace: anonymous unchanged; tier matrix; fail closed; the view under the cap; one owner shape wish, approve and Pages redeploy; stopped host shows the cloudbox offline page. Record evidence on this story. Spec: docs/sprint-615-master-execution-plan.md

LIVE EVIDENCE 2026-11-18 (conductor), host shape-codespaces-qiang.li-shaping (Codespace, outpost c4e1154 built from source, attached to the owner's satellite), engine face /matrix/h/shape-codespaces-qiang.li-shaping/app/site/:
1. Anonymous through the satellite: page 200 (60838 B), root-absolute assets rebased (CSS 200), panel injected once, api/fields empty, view refused (403, after the edge's double-submit CSRF passed), forged owner/circle headers -> anonymous. The static site is unchanged; no private field appears in the static build (the fields live only in the private companion repo).
2. Tier matrix on the real host with stamps signed by the app's real SSO secret: owner -> certificates, contact, owner-notes; recruiter member -> certificates, contact; other-circle member -> none; signed-in pseudonym -> none. All non-anonymous tiers are offered the recruiter-summary view.
3. Fail closed: owner-notes (no audience) is owner-only; unsigned or forged headers are anonymous.
4. Free AI: Gemini OpenAI-compatible endpoint, gemini-flash-lite-latest, key from the vault (account gemini-free). The recruiter summary includes the recruiter-only facts; the stranger summary is built from public text only. GitHub Models was unusable (every path answered a plain 200 OK).
6. Stopped host: the browser gets cloudbox's offline page ('... is offline', retries every 30 seconds); qiang.li stays 200. On restart, startup reran by itself, kept the same host name and pairing, and served again.
OPEN: owner and recruiter checks in a real browser session (operator); step 5 (owner bashy shape wish) after that; the signed-in tier through the satellite needs the S665 admission rung.
