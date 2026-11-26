# Plan: the reverse-SDLC workflow, end to end, and dogfooding it on bashy's apps

*Status: plan for operator review, written 2026-11-26 at the close of
Sprint 723. It turns the proposed process in
`shapeware-qualification-process.md` into a working loop and schedules the
dogfood proposal recorded as D22 to D24 (Sprint 712). Nothing here starts
before the review.*

## Goal

Establish software shaping as one repeatable workflow, "reverse SDLC":
an app ships as a spec that agents build, judge and repair. The workflow
covers the judge, the worker roles and their band levels, the processes,
and the skills and runbooks. It is then run on every bashy application, and
each run adds evidence that improves the specs, the judge and the bands.
New tools and models join by passing the same drills.

## What Sprints 722 to 725 established

| Piece | State | Evidence |
|---|---|---|
| Spec format and soundness criteria | drafted; criteria 1 to 3 mechanical | `shapeware-spec-v0.md` §20; `conform spec check` flags the three v1 gaps and is clean on v2 |
| The judge | works for CLI and page inventory; one page interaction is scripted outside conform | conform v0.1.1 plus `spec check`; two judge defects found and fixed in Sprint 722, none in 723 |
| Spec → source (builder role) | proven on one app | `form` from spec v2 with the judge in the loop: three vendors' start tiers and three step-down tiers pass 3 of 3 (see the Sprint 723 report) |
| Drill method | written down | `spec2src-protocol-v2.md`; kb runbook `spec-to-source-drill` |
| Authoring and building guides | written, not yet tested on an agent | kb runbooks `shapeware-spec-from-app`, `shapeware-source-from-spec` |
| One name for the judge | done | bashy 64d3381a: `conform` is the judge; bashy's own batteries are `selftest` |

## What is missing for an end-to-end workflow

| # | Gap | Why it matters |
|---|---|---|
| W1 | **Only one app has a spec.** `form` is the only shapeware folder among 8 desk apps and about 50 examples. | Nothing shows the criteria generalize. |
| W2 | **The spec-author role is unmeasured.** Both `form` specs were written by the conductor. | Dogfooding at scale needs agents to write specs. |
| W3 | **The judge role is unmeasured.** Hidden cases, failure classification and the judge audit were done by the conductor. The Sprint 723 judge study (S9) did not run. | The conductor is the bottleneck and a single point of bias. |
| W4 | **The drill is driven by hand.** Run, probe and grade scripts live in a private evidence directory; amendments were needed for the snapshot rule, the quiet-workspace cutoff, the agent shell and quota wording. | Not repeatable by another agent; each trap cost runs. |
| W5 | **The loop host differs from the venue.** The subject's judge runs on the session host, the grader on the stated Linux venue. | A build passes in the loop and fails at the venue. |
| W6 | **Results do not feed anything.** No qualification record is written; registry bands are still seeded; a spec's `min-band` is not set from evidence. | The routing rule (cheapest qualified binding) cannot run. |
| W7 | **Quota is unmanaged.** Two of five vendors ran out during one night's drill. | Drills stall; a refusal is mistaken for a failure. |
| W8 | **Accounting is partial.** Tokens are recorded for two tools only; cost for none. | Minutes and cost per effort point cannot be measured. |

## Roles and who fills them next

The conductor stops doing role work and only supervises, gates and merges.

| Role | Next iteration | Qualifies by |
|---|---|---|
| Spec author | one agent binding writes the spec for the second app | `conform spec check` clean, reference certifies, every mutant killed, and qualified builders reproduce the app |
| Judge | a different vendor's binding writes the hidden cases and classifies the failures | reference 3 of 3 and null fails on its cases; its classification compared with the conductor's on the same evidence |
| Builder | the bindings that passed on `form`, on the second app | 2 of 3 or better through the drill |
| Conductor | protocol, gates, amendments, merges | the operator's review |

A binding never fills two roles on the same app, and a subject binding gets
no worker story that touches the drill.

## Sprints (bounded; only the first is filed)

### Iteration 2: the MVP end-to-end loop on a second app, run by agents (filed, backlog)

KISS: the smallest slice in which every role is filled once by an agent,
with the tools that already exist. Four stories, nothing new built.

1. **Reverse (W1, W2).** One binding writes the shapeware spec for the
   second app from the kb runbook `shapeware-spec-from-app`. Done when
   `conform spec check` is clean, the reference certifies and every mutant
   is killed. Recommended app: `notepad` (about 2,000 lines, one service,
   one page; closest in size to `form`).
2. **Judge (W3).** A binding from another vendor writes the hidden cases
   from the kb runbook `spec-to-source-drill`. Done when the reference
   passes them 3 of 3 and the empty workspace fails.
3. **Build.** Two bindings that passed on `form`, from two vendors, 3 runs
   each, with the Sprint 723 harness as it is (same scripts, guard, grader
   and amended conditions; only the fixture and the hidden set change).
4. **Close the loop (W6, minimal).** The measured `min-band` goes into the
   app's `SKILL.md`, the results table goes into a short report, and every
   point where an agent had to guess becomes a fix to a runbook.

Acceptance: the second app is rebuilt from an agent-written spec and judged
with agent-written hidden cases, by two vendors' bindings at 2 of 3 or
better, with no conductor-authored spec or case.

**Not in the MVP** (recorded, not filed): the drill as registered commands
(W4), venue parity in the loop (W5; the grader already drops stale
binaries), a quota check and vendor refusal wording (W7), full accounting
(W8), qualification record files and registry wiring (W6 beyond the
`min-band` line), a judge-written failure classification, and more than
two builder bindings.

### Later, in order (not filed)

- **Judge qualification** (the deferred S9): L4 against L5 evaluators on
  the evidence of Sprints 722, 723 and iteration 2.
- **Dogfood wave 1:** the remaining desk apps (`chart`, `viewer`, `page`,
  `gallery`, `evidence`; `kit` is a library and needs its own decision),
  each through the same loop under the two-vendor rule of D22.
- **Bands from evidence** (Sprint 559): qualification records into the
  registry, the composite band, and the routing rule.
- **Dogfood waves 2 and on:** the other bashy examples in small batches,
  grouped by kind. Each wave is its own sprint with its own plan, as the
  mass-change rule requires.
- **Standing intake:** a new tool or model runs the builder drill on the
  sealed specs, then the judge drill, and gets its record and band.

## Scope and non-goals

- In scope: agent-bench, conform, the spec files of the apps, kb runbooks,
  private hidden cases.
- Not in scope: changing any app's behaviour, the shell interpreter or
  coreutils; a release; paid-by-usage models without the operator.

## Budget, venue and risks

- **Quota is the constraint, not time.** A full drill is 3 runs per binding;
  one vendor's plan allows roughly one drill per reset window alongside
  normal work. Iteration 2 needs 6 builder runs plus two role sessions.
- **Venue:** sessions on the dev box; every build, test and grade on a
  claimed gate lane.
- **Risks:** an agent-written spec that is unsound (caught by the checker,
  certification and mutants before any builder runs); agent-written hidden
  cases that test undocumented behaviour (caught by the reference control
  and the conductor's gate); the second app needing a UI interaction the
  judge cannot script yet (then the interaction stays a scripted private
  case, as for `form`).
- **Rollback:** each app's spec is additive files in its own folder.

## Decisions for the operator

1. The second app: `notepad` (recommended) or another.
2. Role bindings for iteration 2: spec author and judge from two different
   vendors, both at L5 for the first agent-run iteration (recommended), or
   start lower.
3. The two builder bindings (recommended: the two cheapest that passed on
   `form`, from different vendors).
