---
id: 26831ffd110a
kind: bug
title: 'S583/S606 carry-over: member-bound door peer through the satellite, plus closing verification'
seq: 98
status: todo
priority: p1
labels:
    - llm
    - satellite
    - carryover
created: 2026-11-10T22:14:46.774113Z
sprint: 613
sprint_id: 0072ec8f-a661-5f88-9ee1-e43cae87349f
sprint_title: 'lern-psic UAT: full-suite close-out of the S607 candidate and member go-live guards'
---

Carried over when Sprints 583 and 606 were closed on 2026-11-10 at operator direction. The design rule holds: once an outpost is paired and access is shared, permission is assumed, and the door authorizes each request itself (yoke 2eb6733da6ad).

Remaining:
1. Member-bound peer through the satellite. In e2e door-by-member (cloudbox harness 93b4ee4+, cloudbox f07682c, bashy 4dae524b), everything passes except the last step: a mutual member's own request (agent Bearer, host:proxy) to the door through the satellite times out. Passing steps: grant half, llm peer add NAME --email E (fixed by f07682c: the host token reads its owner's members).
   Hypothesis, unverified: llm share publishes the door app without trusted-identity forwarding (outpost apps add --trust-cloud-identity), so the door cannot identify the member. Start from the run evidence (cloudbox .e2e-multisat/evidence.json, logs sat-S / llm-door2 / outpost-e2e-door2), then the root cause, then the fix.
2. Re-run the bashy agentos group in the sealed Linux container at bashy main. This confirms the yoke src pin fix 4dae524b (red/green on macOS only).
3. Bump the umbrella pins for bashy, yoke, outpost and bashsharp once the umbrella bashy checkout is free (weave run 69).

Already green (do not rerun): multisat, members, federation 8 of 10, llm-door (only BLOCKED by design), yoke broker/webconsole, cloudbox handlers/middleware/server, bashy core/frontend/tooling, Bash 5.3 86/86 in both modes (reuse). outpost has only the pre-existing filed failures (84ac2dc73e33).
Acceptance: e2e door-by-member PASS on the Linux test host; agentos group green; pins bumped.
