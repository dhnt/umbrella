---
id: bd375df7b100
kind: task
title: 'E0 plan from the 2026-11-13 commercialization brainstorm: E1 as wish-log replay, E3 regenerate arm, DIY-starter catalog, first-bet sequence'
seq: 235
status: todo
priority: p3
labels:
    - shaping-eval
    - planning
created: 2026-11-13T17:03:55.142508Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

PLANNING STORY. Adjust the Sprint 632 plan before E1-E4 run. The requirements are the OPERATOR POSITIONS below. The 2026-11-13 brainstorm (meet room 46) is background information only: its polls, cards and reviewer books carry no decisions and set no requirements. For information: dhnt-docs docs/meetings/meeting-note-2026-11-13T07-09-commercializing-bashy-software-shaping-product-a.md (private) (minutes, polls, 25-card board) and dhnt-docs docs/shaping-commercialization-analysis.md (private) (compiled analysis of the minutes, the board and the four reviewer books).

OPERATOR POSITIONS (the requirements; where the meeting notes differ, these win):
1. Receivers of a shaped app never pay; charge for operation, governance and evidence, in flat units, never per seat or per wish.
2. The catalog is a publicly hosted, free, open-source set of production-grade STARTER apps that people copy and shape for themselves (DIY). Contributions back are not expected; feature requests arrive as community discussions and become a starter change only when they recur. New feature coding is cheaper than resolving or merging changes: regenerate, do not merge.
3. Roadblocks named by reviewers are hypotheses, not verdicts. Sort them: paradigm-bound (fork maintenance, merge-based upgrade survival, wish cost) vs change-shape (verification becomes the bottleneck, shared business data vs per-person variants, team agreement on one version) vs invariant (who pays, irreversible external effects, personal-data liability, support hours, trust). Attach a cheap test to each instead of arguing.

DELIVERABLES
a. E1 (3d9357e5) rewritten as a REPLAY test: an app is a starter version plus an ordered, replayable wish log; upgrade survival = replay the log onto the newer starter. Measure per app: replayed clean / replayed with an agent fix the owner approved / flagged / failed. Check first whether `bashy shape` can replay a wish history onto a new base; if not, that capability is the E1 prerequisite.
b. E3 (6a4586c7) gets a third arm: "regenerate from the wish log" alongside the AI coding agent and SaaS configuration, measured on the same elapsed time, model cost, review minutes and post-approval defects.
c. Decide where the shared-team-data vs per-principal preview separation and the thin shaping seam (UI sidecar routes, Bash# event/cron hooks, additive schema through the app API) live: inside E2 (eac13ecf) or a prerequisite story. E3's unpaid-orders wish cannot pass through a stylesheet-only seam.
d. Catalog rule written down for the starters page: how many starters are kept patched this quarter (each is a standing obligation: build against upstream, patches, no-phone-home), what "production grade" means (contract-derived checks and fixtures, not just "it runs"), and the discussions-to-starter rule.
e. A first-bet sequence PROPOSED to the operator for confirmation (the analysis suggests: gate on E1-E3; founder-led retainer with 3-5 similar small businesses as the evidence vehicle; class satellite term 2 converted to paid and reported as hosting revenue, never as shaping proof; team governance once there is a team with approved shapes; vendor kit and any shape registry last). Only what the operator confirms goes into the sprint plan. Already ruled out by position 2: shape-merge retainers, certified-shape registries, upstream promotion as a product.
f. Open questions answered with the operator and recorded on the card: pricing unit to test first (per business vs per governed app line); starter count; whether classroom revenue is reported separately from shaping.

ACCEPTANCE: E1 and E3 story texts updated and linked from this story; (c) decided and filed; catalog rule and sequence committed to the sprint plan doc; open questions (f) answered or explicitly deferred with a reason. No runtime proofs in this story; measurements belong to E1-E4 on the claimed gate venue.
