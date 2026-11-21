---
id: 46743cdd0cda
kind: refactor
title: 'P2 (ex-S6): bsh certified binary - NEW small main linking bashsharp cli + coreutils (zero yoke), frozen digest'
seq: 556
status: wontfix
priority: p0
labels:
    - bashy
    - coreutils
    - yoke
    - architecture
created: 2026-11-20T10:01:53.955495Z
assignee: agy-opus5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T12:17:46.437821Z
---

REPLAN 2026-11-21 (operator rejected 4-7d ETA; conductor-verified groundwork): P2 = a NEW small main linking bashsharp cli + coreutils - both link ZERO yoke today and the standalone bash/CLI split was delivered in Sprint 575. Do NOT sever bashy internal/core (that was the old S6 scope; dropped). Repos: bashy (new cmd), bashsharp, coreutils. Deliverable: bsh entry point (Bash 5.3 + Bash# + POSIX-required coreutils in one binary), link proof of zero yoke packages (go list -deps evidence on this story), bsh size + warm build time measured (vs P1 baseline when it lands; record raw numbers regardless). Target: hours, not days. Gates: targeted tests on dev box via bashy dag; the Bash 5.3 86/86 both-modes gate for bsh runs ONCE at the sprint-final gate (operator rule: full e2e once all features complete), where the frozen bsh digest is recorded; later bsh changes need re-certification. Supersedes Sprint 575 S1 49e058e0 + S1C 85d6a32c (pointers already on both; close them as superseded when this is accepted). Commit per stage (main builds / link proof / numbers). Root cause before any red-test fix (directive #3); trailers + Agent (directive #4).

OPERATOR RULE 2026-11-21 (typed, supersedes earlier 'final run at sprint end' wording): this story ships enough FAST unit-test coverage, written and RUN while building (smallest maintained tests in the repo's normal layout, asserting the changed behavior). Integration tests (go test ./..., Bash 86/86, 3-OS dispatch e2e, browser/judge tests, release gates) run ONLY at epic/milestone completion via .bashy/gate.final when the conductor calls the milestone - NOT per story, NOT per sprint. Any earlier text in this story saying 'sprint-final gate' means that milestone integration gate. Per-story gate (.bashy/gate) is build-only. Record skipped integration checks in the submit as 'deferred to milestone integration gate (gate.final, conductor-called)'.

SYNC RULE (operator 2026-11-21, typed; conductor relay): never work on outdated code. (1) Start from CURRENT origin default branch of each repo touched, never stale umbrella pins or the shared checkout. (2) Before submit: rebase onto current origin (incl. S0 baseline sync 6ce2c2cb once landed) and rerun this story's unit tests. (3) After merge, manager syncs consumer go.mod pins (producer push first) + umbrella pins. (4) This story is not accepted while 'bashy mod drift' shows stale/cycle for modules it touched. (5) No long-lived branches left to rot.

CLOSED-BY-RESCOPE NOTE (manager, 2026-11-21): run #114 delivered cmd/bsh inside the bashy module (manager-verified additive: 515 deps, 0 yoke, unit tests ok, 31.0MB) but the operator rescoped bsh to its own module in bashsharp BEFORE merge. #114 abandoned after preservation (salvage/s677-p2-114, salvage/s677-p2-umbrella-114). Delivery continues as P2b 9c7c5a8b8f70; this story closes as superseded when P2b is accepted. Do not staff.
