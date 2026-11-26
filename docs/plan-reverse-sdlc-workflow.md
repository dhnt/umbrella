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

### The front half: instructions to spec (two stories filed, no sprint yet)

Operator, 2026-11-26. A shapeware release can be the spec itself, shipped
as the application: a user asks their agent to start shaping, and the agent
builds and runs the app on the fly. The spec format already carries this
(features with `status: tbd`, acceptance lines, the release class "verified
with tbd"; `shapeware-spec-v0.md` §5 and §12). What is missing is the step
before the spec.

- **Assumption, to be measured later:** premium models (the top tier of
  each vendor) can turn a user's instructions into a sound shapeware spec.
- **Sources of instructions:** a plan written by an agentic tool's plan
  mode, and a bashy sprint card with its stories or a set of todos.
- **Story P1 (runbook):** `shapeware-spec-from-plan`: convert a plan, or a
  bashy sprint or todo set, into a shapeware spec folder. Each story or
  plan step becomes a feature with an intent, an effort estimate and
  acceptance lines; behaviour that must hold becomes contract assertions;
  everything starts `tbd`. `conform spec check` must be clean. With no
  reference app, the first build that passes becomes the reference.
- **Story P2 (evaluation):** the same instructions given to top-tier
  bindings of three vendors; each writes a spec; a qualified builder builds
  from each. This is the spec-author drill for new apps, and it tests the
  assumption above.

These follow iteration 2 and do not change it.

### The full trip: spec to a running app (Sprint 731, started 2026-11-26)

Sprint 731 now also carries the workflow standard (the former Sprint 728,
merged by operator order): the standard is written alongside the trip and
uses `form` as its proof, stage by stage. The notepad forward test and the
judge study are back in the unsprinted backlog.


Operator, 2026-11-26. Spec to source is one leg. A shaping trip ends with
the app installed and running: a command for a CLI, a service for a web
app. The format already fixes the lifecycle as five exact,
non-interactive `dag.md` steps (source, build, test, install, run), with
more allowed (`serve`, `show`); `form` has all seven
(`shapeware-spec-v0.md` §5a).

| Stage | Who | Output | Gate | Band expected | State |
|---|---|---|---|---|---|
| 1 Instructions to spec | spec author | spec folder | owner review of open questions | top tier (assumed) | one observation (Sprint 727) |
| 2 Compile the spec | no model | findings | lint clean; later a dry run | none | lint built |
| 3 Spec to source | builder | source and launcher | the judge, visible and hidden | middle tier and one below pass on `form` | measured (Sprint 723) |
| 4 Source to artifact | operator agent | built binary or verified core | `dag build` exits 0 | low | not measured |
| 5 End-to-end test | no model | PASS/FAIL lines | `dag test`: the contract and acceptance checks on the built app | none | exists for the reference |
| 6 Install or deploy | operator agent | registered command, skill and app on the user's machine | consent gate; `dag install` exits 0 | low | not measured |
| 7 Run or serve | operator agent | a CLI answer; a page served | the contract again, against the installed app | low | not measured |
| 8 Use and shape in the field | any agent | answers; known issues handled; `tbd` features built | the installed folder's checks | measured once (Sprint 721 pack: use, known issue, tbd) | partly measured |

**Where end-to-end tests belong.** They are the spec's contract and
acceptance checks, and they ship with the spec. No separate suite. They
run twice: at stage 5 on the fresh build, before anything is installed,
and at stage 7 against the installed, running app, which is the only run
that proves the trip. Both are run by the judge, not by a model, and a
shaping pass may not change them. The owner's hidden cases stay private
and are used for qualification, not shipped.

**The band expectation.** Stages 4, 6 and 7 are exact steps with one
source of truth, so they should need a much lower band than stage 3, down
to small local models. That is a hypothesis until measured; the pilot of
Sprint 721 measured stage 8 only.

**Operator ruling, 2026-11-26: no separate pipeline. The lifecycle is part
of the spec.** A shapeware release carries its `dag.md`; that file is
sufficient for build, install, deploy and run, and it states the least
agent that can carry out each step. The real deployment depends on the
user's infrastructure and is done there by the user's agent, behind the
consent gate. The table above is therefore not a pipeline to build; it is
what one `dag.md` describes.

What this means in the format:

- **`dag.md` is required in a spec,** not only in a built app. This is
  already the rule for a published release (§5a: a missing step is a lint
  failure).
- **In a spec-only release, the `build` step is the spec-to-source step:**
  "an agent at band X builds this from the contract; the judge decides".
  `test` is the contract. `install`, `run` and `serve` are exact commands
  where the venue is known, and a stated goal with a check where it is
  the user's own infrastructure.
- **Each step states its minimum band next to its effects.** Steps already
  carry an `Effects:` line; a `Band:` line is the one addition. Build
  needs the builder's band; install, run and serve are expected to need
  much less.
- **A stated band is a measured band.** The value comes from a drill, as
  the minimum band of an app does (D23), never from an estimate.
- **The contract is rerun against the installed app,** so the result is
  checked however the deployment was done.

**The gap found while writing this.** The Sprint 723 builders delivered
source and a launcher, not a shapeware folder: no `dag.md`, no install
step. With the lifecycle in the spec, the builder is handed the `dag.md`
and must make its steps work, instead of inventing one.

| Story | What it delivers |
|---|---|
| T1 the lifecycle in the spec | `form`'s spec folder carries its `dag.md` with a `Band:` line per step; a `conform spec check` rule requires the five steps and a band on each; the spec-to-source task hands the builder that file, and the grader checks at the venue that `build`, `test` and `run` work. One builder that already passed, 3 runs. |
| T2 the operate drill | A low-band binding gets a built folder and its run block, cold, and must run the lifecycle: build, test, install, one CLI command, start the service, fetch the page, stop it. Graded mechanically by exit codes and the contract against the installed app. Ladder downward; this measures the `Band:` values. |
| T3 record the measured bands | The measured values go into `dag.md` and `SKILL.md`, as bounds where the ladder was not exhausted. |
| T4 report and runbook | A short report of the trip and a kb runbook for the operate stages. |

### The field loop: issues in, shaped fixes out (Sprint 730 filed, backlog)

Operator, 2026-11-26. Two things: issues must have a place in the spec,
and an app should be able to work on its own issues while it runs.

**Superseded as the sprint's plan** by
`docs/sprint-730-master-execution-plan.md` (review of 2026-11-26). That
document adds two stories (L0 format decisions, L6 an expected-fail mode in
`conform cert`), drops L4's dependency on yoke todo `55730ebaf952`, which is
not built, and records that incident repair activates without the owner
today. The table below is the plan as first filed.

**What the format already has** (`shapeware-spec-v0.md` §4.2, §4.3, §5):
a known-issue entry (`KI-n`, status, the feature it belongs to, symptom →
action, retry bound, expiry, todo), features marked `tbd` with acceptance
lines, and the Build intent (work copy, graded by the installed folder's
`candidate.bsh`, "offer, never self-approve"). `form` carries one real
known issue (KI-1) and one real `tbd` feature (`group-required`).

**What is missing:** the step from an incoming issue to those entries, a
feed to take issues from, and a loop that runs it without a person
starting each pass.

| Story | What it delivers |
|---|---|
| L1 issue to spec | A kb runbook: classify an incoming issue and write it into the spec. A **bug** becomes a known-issue entry plus an acceptance example that fails today; a **new feature** becomes a `tbd` feature with acceptance lines; a **missing or `tbd` feature** that someone needs becomes a Build request for the existing entry. Open questions go to the owner, as for any spec change. |
| L2 lint for issues | `conform spec check` rules for the compile step: a known issue names an existing feature, has a status and an expiry; a bug's example exists; a `tbd` feature has acceptance lines; a `critical` feature has no open issue. |
| L3 one issues feed | The smallest feed: one designated source (a label on one GitHub repository's issues, or one chat channel) read into issue records with a stable id, text and reporter. Read-only; the feed never authorizes anything (text is data). |
| L4 the loop on one app | For `form`: an issue arrives from the feed, or the app's own check fails while it runs; an agent applies L1, builds in a work copy, and the installed folder's checks and the judge decide. A pass is offered to the owner; a failure leaves a known-issue entry. One bug and one `tbd` feature end to end. |
| L5 guard for unattended shaping | Bounded effort per issue, the installed effect cap, no change to critical features or the trusted core, every action logged, a switch that turns the loop off, and the owner's approval before anything is kept. |

Related work that this reuses, not repeats: yoke todo `55730ebaf952`
(hand a failed command trajectory to the repair loop) and umbrella todo
`af84c70fd72c` (telemetry review for agentic self-healing), both on
Sprint 611.

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
