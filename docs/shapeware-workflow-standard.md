# The shapeware workflow standard (v0, first draft)

*Written 2026-11-26 for Sprint 731. It answers the eight questions of
`shapeware-workflow-findings-2026-11-26.md` §4 (story W1; questions 6 and
7, how an app enters and how a new tool or model joins, in §8 to §11 by
story W2) and uses bashy's `form` app as the proof, stage by stage. It is a
draft for the operator review (story W3).*

Shaping is iterative. No pass is expected to produce a perfect app; the
workflow makes each pass cheap, checkable and safe to repeat.

It links rather than restates: the format is `shapeware-spec-v0.md`
("the format", with §), agent qualification is
`shapeware-qualification-process.md` ("the qualification process"), the
plan is `plan-reverse-sdlc-workflow.md`, and the evidence is
`sprint-723-report.md`, `spec2src-protocol-v2.md`, `handoff-sprint-731.md`
(the `form` spec v2.1 re-certification) and the kb runbooks named below.

## 1. Terms (each defined once)

| Term | Meaning |
|---|---|
| **Shapeware app** | Software that ships as a folder holding its spec, lifecycle, checks and known issues, so that agents can build, run and repair it (the format, opening section). |
| **Spec folder** | The source of a shapeware app: `SKILL.md`, `CONTRACT.md`, `features.yaml`, `examples/`, `dag.md`, `contract.bsh`. A spec folder with no code yet is still a release (see §4). |
| **Contract** | `CONTRACT.md`: rules, then numbered assertions (a command, its expected output, its exit code), plus page (`ui`) assertions (the format §19). |
| **Lifecycle** | `dag.md`: the exact steps `source`, `build`, `test`, `install`, `run`, plus optional ones such as `serve` (the format §5a). |
| **Judge** | `conform` (repository `dhnt/conform`, shipped in bashy as `bashy conform`): it runs a contract against a build and reports every assertion by name. No model is involved. |
| **Hidden cases** | Private assertions in the contract's format that vary documented behaviour (other ids, values, field sets). They are used to qualify builders, never shipped. |
| **Reference** | The build that a spec version is certified against. |
| **Binding** | One agentic tool with one model, for example `codex-gpt6.1-terra`. |
| **Band** | A level L1 to L5 for what an agent can do, held per binding and per role. `none` means no model is needed. |
| **Venue** | The stated machine conditions a build must work on (OS, toolchain versions, network, what is absent). |
| **Work copy** | A fresh copy of the folder in which an agent makes a change; the installed folder's checks grade it (the format §2, §6). |
| **Lift** | To turn an existing app's source into its shapeware spec, so that it can be shaped (kb runbook `shapeware-lift-app`; the reverse step of §3). The official word, adopted 2026-11-27. |
| **Surface folder** | Where a lifted surface lives: `shapeware/<surface>/` at the repo root, one folder per surface; a self-contained app is its own folder. `shapeware/index.bsh` lists, locates and lints them (the format, §1 and Appendix C). |
| **Shaping pass** | One change carried through the stages below and judged: a new spec, a new feature, a fix. |
| **Release class** | The computed claim about a folder, from **blocked** to **verified** (the format §12). Never written by hand. |

## 2. Rules

These are operator rulings (2026-11-26) and the lessons of Sprints 722 to
729. They hold for every stage.

1. **No separate pipeline. The lifecycle is part of the spec.** Every spec
   folder carries its `dag.md`. Each step states its effects (`Effects:`)
   and the least agent that can carry it out (`Band:`). The stages in §3 are
   what one `dag.md` describes, not a pipeline to build
   (`plan-reverse-sdlc-workflow.md`, "The full trip").
2. **A stated band is a measured band.** A `Band:` line or a
   `metadata.min-band` value comes from a drill. Until then it says
   `unmeasured`, or it is a bound with its source. An estimate is never
   written as a band.
3. **A spec is compiled before it is built.** Lint now (`conform spec
   check`), a dry run later. Compiling needs no model and takes seconds; an
   error blocks the build.
4. **End-to-end tests are the spec's contract.** There is no separate test
   suite. The judge runs the contract on the fresh build (stage 5) and again
   on the installed, running app (stage 7). A shaping pass may not change
   the existing assertions or checks (the format §6).
5. **Two human gates.** The owner approves what the app is (the spec
   review). A person consents before it runs on a machine they answer for.
   Everything else is mechanical. See §5.
6. **Every non-pass is classified by cause:** spec gap, agent defect, judge
   defect or venue fault. The classification is what improves the spec
   (finding F3).
7. **Venue faults are fixed in the venue, never scored.** A provider quota
   refusal, a runner cutoff or a stale binary is a venue fault: the cell is
   rerun and both attempts are kept (`spec2src-protocol-v2.md`, amendments
   1 to 4). The venue is written in the spec.
8. **Separate bindings for separate roles.** A binding never fills two roles
   on the same app (`plan-reverse-sdlc-workflow.md`, "Roles"). Claims stay
   narrow: exact bindings, runs and versions; one ladder step gives a
   bound, not a minimum (`spec2src-protocol-v2.md`, "Reporting").

## 3. The stages end to end

**Proven**: measured on `form` with recorded evidence. **Partly proven**:
a part measured, or measured elsewhere. **Not yet proven**: nothing measured.

| # | Stage | Who (least band) | Artifact | Gate | Evidence left | State |
|---|---|---|---|---|---|---|
| 1 | Instructions to spec | spec author (top tier, assumed) | spec folder with open questions | **human:** owner review | the spec version; the owner's decisions | partly proven, not on `form` |
| 2 | Compile the spec | no model | lint findings | mechanical: no error finding | the lint output for the spec digest | partly proven (lint only) |
| 3 | Spec to source | builder (`unmeasured` as a band; bounds per binding below) | source plus launcher, in a work copy | mechanical: the judge, visible contract (hidden cases when qualifying) | per-assertion verdicts, digests | proven on `form` |
| 4 | Source to artifact (`dag build`) | operator agent (`unmeasured`) | built binary or verified core | mechanical: the step exits 0 | the step log | proven on `form` |
| 5 | End-to-end test (`dag test`) | no model | PASS/FAIL/TBD lines | mechanical: no FAIL | the lines; the judge's verdicts | proven on `form` |
| 6 | Install (`dag install`) | operator agent (`unmeasured`) | the app installed for agents and people | **human:** consent, then the step exits 0 | the consent record; the step log | partly proven (no consent gate) |
| 7 | Run or serve (`dag run`, `dag serve`) | operator agent (`unmeasured`) | a CLI answer; a served page | mechanical: the contract again, on the installed app | the judge's verdicts | proven on `form` |
| 8 | Field shaping | any agent at or above the feature's floor | a graded work copy, a known-issue entry | mechanical: `candidate.bsh`; **human:** owner keeps it | the candidate's PASS/FAIL lines and variant id | partly proven |

The stages are a loop: stage 8 feeds stage 1, since a request or a bug
becomes a spec change that is compiled, built, tested and offered again.

### Stage 1: instructions to spec

A spec author turns instructions (a plan, a sprint card and its stories, a
set of todos) into a spec folder, following the kb runbook
`shapeware-spec-from-plan`. Everything starts `tbd`. Where the instructions
are silent, the author writes an open value under "Open questions" and
never guesses a literal. The **owner review** settles those questions
before anything is built (gate 1, §5). An existing app enters by the
reverse step instead: it is **lifted** (kb runbook `shapeware-lift-app`).

*`form`:* its spec came by the reverse step, not from instructions, and was
written by the conductor: v1 (Sprint 722), v2 after the seven measured gaps
(`plan-spec2src-calibration.md`), and v2.1, which defines the secret-name
rule with assertions F-14 to F-16 (`handoff-sprint-731.md`).

*State: partly proven.* Instructions to spec was observed once, on another
app: three top-tier bindings wrote lint-clean specs from the notepad
stories in 3 to 7 minutes, and the three specs differed in names and in
one guessed value that failed their contracts against the existing app
(findings §1, F6 to F8). No owner review has been run, and no spec from
instructions has been built yet (unsprinted story `e130889b`).

### Stage 2: compile the spec

`conform spec check DIR` reports findings in seconds with no model. It
checks soundness criteria 1 to 3 (the format §20), a rule given only by
example (conform `40c5602`, Sprint 729), and the lifecycle: five steps,
each with an `Effects:` line and a `Band:` of `none`, `unmeasured` or `L1`
to `L5` (conform `1be6b39`). As built, every finding is an error except a
missing `dag.md`, a warning. **Rule:** an error blocks the build; a warning
is allowed only in a draft (a published release needs all five steps, the
format §5a). The builder lints first and writes down how it read any
finding (kb runbook `shapeware-source-from-spec`, step 0).

*`form`:* the lint flags the three v1 gaps and is clean on v2
(`plan-reverse-sdlc-workflow.md`, "What Sprints 722 to 725 established").
The rule-by-example check was written from the one Sprint 723 spec gap
(`sprint-723-report.md`, "Failures by cause").

*State: partly proven:* lint is built and shown on `form`; the dry run
(findings §4a) is not built.

### Stage 3: spec to source

A builder, given only the spec folder and the judge, writes source and a
launcher in a fresh work copy, running the judge while it works (kb
runbook `shapeware-source-from-spec`). The judge decides. To qualify a
builder, the private hidden cases and the page interaction are added and
graded at the venue (kb runbook `spec-to-source-drill`).

*`form`:* with spec v2 and the judge in the loop, these bindings passed
every visible assertion, every hidden case, both page inventories and one
page interaction: `codex-gpt6.2-sol` 3/3 and one step down
`codex-gpt6.1-terra` 3/3; `muse-spark1.3` 3/3 and `muse-ember` 3/3;
`claude-sonnet5.5` 3/3 on rerun after a harness fix, and `claude-sonnet5`
2/3; `agy-gemini4-carbon` 3/3 on rerun, step down not run
(`sprint-723-report.md`). Controls: the reference passed 3/3 and the empty
workspace failed every assertion. With spec v1, cheapest models and no
judge in the loop, 1 run in 15 passed (Sprint 722; context, not a
controlled comparison; same report).

*State: proven on one app.* Limits: one app, conductor-written spec and
hidden cases, n = 3 per binding, results are bounds. Registry bands for
these bindings are still seeded, so the builder band of `form` is known
only as these per-binding bounds, not as an L value.

### Stage 4: source to artifact

An operator agent (an agent that carries out lifecycle steps; it writes no
source) runs `dag build`: compile, or verify the pinned core digest, or
parse-check (the format §5a, §9).

*`form`:* its `dag.md` build step parse-checks `form.bsh` and builds the
core server; `Band: unmeasured`. The Sprint 723 builders delivered source
and a launcher, not a folder with a `dag.md`, so no builder's `dag build`
has been run (`plan-reverse-sdlc-workflow.md`, "The gap found while
writing this"; story T1).

*State: proven on `form`.* With the lifecycle handed to the builder, `codex-gpt6.1-terra` supplied a `build.sh` that exits 0 at the venue in 3 of 3 runs, and in the operate drill two lower-tier bindings and a script with no model ran the step (`sprint-731-report.md`).

### Stage 5: end-to-end test

`dag test` runs the contract and the acceptance checks on the fresh build,
before anything is installed. No model. Every assertion is reported by
name. A spec version is certified only when the judge passes the reference
3 times with no noisy assertion and kills every seeded mutant (the format
§20).

*`form` spec v2.1:* the reference certified 17 of 17 assertions over 3 runs
with no noisy assertion, 117 of 117 mutants were killed, and the app's own
acceptance checks print 11 PASS and 4 TBD (`handoff-sprint-731.md`,
"Nothing is in flight"). For every Sprint 723 build, the grader ran the
contract at the venue (`spec2src-protocol-v2.md`, "Grading venue").

*State: proven on `form`:* the spec's `test` step, run at the venue on each
builder's folder, exits 0 in 3 of 3 runs (`sprint-731-report.md`).

### Stage 6: install

Before the first build, install or run on a machine, the **consent gate**
shows the person who answers for that machine what the spec will do there: the
effect cap (`contract.bsh`; the format §7), the `Effects:` and `Band:` of
each step, the lint warnings, the release class and the measured minimum
band. Nothing runs without an explicit yes. Later passes inside the
approved cap do not ask again; anything beyond it does. Every approval and
every override is logged (findings §4a). Then the operator agent runs `dag
install`. On a machine without bashy, install means a launcher on the PATH
(`handoff-sprint-731.md`, rulings in force).

*`form`:* the effect cap is `read,write,exec,net`; the install step runs
`register.sh`; `Band: unmeasured`.

*State: partly proven.* The install step, a launcher on the PATH, was run
cold 3 of 3 by `codex-gpt6-luna` and by `opencode-glm-5.3-flash`, and by a
script with no model (`sprint-731-report.md`). The consent gate exists only
as parts (the cap, the computed class, no cap raise by a candidate).

### Stage 7: run or serve

The operator agent runs `dag run` (a CLI answer) or `dag serve` (a page).
The judge then runs the contract **against the installed, running app**.
This is the only run that proves the trip, however the deployment was done.

*`form`:* `run` takes `ARGS='...'`; `serve` starts the loopback server.
Both carry `Band: unmeasured`. The one page interaction (fill by label,
submit, read back through the CLI) is still scripted outside the judge
(kb retro `shapeware-drill-retro-sprints-722-725`, "Open").

*State: proven on `form`.* The same two bindings ran one
command, served the page, fetched it and stopped the service, 3 of 3 each,
and the judge passed the contract against the installed app
(`sprint-731-report.md`). The gap found there (no defined `serve` when the
app's own server already runs, and no stop) is closed in spec v2.2: `form
stop` is in the contract, the lifecycle has a `stop` step, and all three
v2.2 builds serve and stop (same report, "After the operator review").

### Stage 8: field shaping

In use, an agent follows the run block (the format §4.3): known issues
first, then use; for a `tbd` feature, build it in a fresh work copy, grade
it with the **installed** folder's `checks/candidate.bsh`, and offer it,
never self-approve. A bug that has no fix yet becomes a known-issue entry
(the format §4.2). The owner decides what is kept and served.

*`form`:* one real known issue, KI-1 (`workaround`, on `submit-answers`),
and one real `tbd` feature, `group-required` (floor `L2`).

*State: partly proven.* The Sprint 721 measurement pack covered use, the
known issue and building the `tbd` feature once
(`plan-reverse-sdlc-workflow.md`, stage table, row 8). The `min-band: L2`
in `form`'s `SKILL.md` was declared before rule 2 of §2 and has not been
measured. The field loop (issues in, shaped fixes out; Sprint 730) is not
built.

## 4. What done means for one shaping pass

A pass is done when all of these hold:

1. **Compiled:** the lint reports no error for the spec version the pass
   produced.
2. **Judged:** the judge has reported every assertion by name on the
   build, and every non-pass is classified by cause (§2, rule 6).
3. **No regression:** the installed folder's `candidate.bsh` passes on the
   work copy, so every existing example still holds and no protected file
   changed (the format §6).
4. **Not blocked:** the computed release class (the format §12) is not
   **blocked**.
5. **Decided:** the owner has kept the candidate or turned it down. Until
   then it is a verified candidate, not the served version.

Any class but **blocked** ends a pass. The format's classes, unchanged:

| Class (the format §12) | What it means in the workflow |
|---|---|
| **blocked** | Not done. Fix, or leave a known-issue entry and stop. |
| **no claims** | A plain skill; not a shaping result. |
| **requirements release** | A spec with no verified feature: the normal end of stage 1. It can ship as the application, for the user's agent to build (stage 3) behind the consent gate. |
| **verified with tbd** | The normal state while shaping. Some features are built and verified; others wait. |
| **verified with known issues** | Every feature verified; some issues have only a workaround. |
| **verified** | Every feature verified, no open issue. |

Only the owner promotes a feature from `tbd` to `verified`; a passing `tbd`
example does not (the format §6).

*`form` today:* five features `verified` (one `critical`), one `tbd`
(`group-required`), KI-1 a workaround on a non-critical feature, and checks
printing 11 PASS and 4 TBD with no FAIL. By the first-match rules of §12
this is **verified with tbd** (rule 7). The class was read from the
recorded state here, not computed by `release-class.bsh`.

## 5. Roles and people

### Agent roles

| Role | What it does | Stages | How it qualifies | State |
|---|---|---|---|---|
| **Spec author** | writes a spec from instructions or from an app | 1 | lint clean, the reference certifies, every mutant killed, qualified builders reproduce the app (qualification process) | unmeasured: both `form` specs were written by the conductor (gap W2) |
| **Judge** | writes the hidden cases; classifies every non-pass with evidence | 3, and the audit of any verdict | the reference passes its cases 3/3 and the empty workspace fails; its classification is compared with a reference judgement | unmeasured: done by the conductor (gap W3; story `6e6632d8`) |
| **Builder** | writes source from the spec alone | 3, 8 | 2 of 3 or better through the drill on a certified spec | measured on `form` (stage 3) |
| **Operator agent** | carries out lifecycle steps exactly as written | 4, 6, 7 | the operate drill: exit codes and the contract on the installed app | unmeasured (story T2) |
| **Conductor** | writes protocols, runs the gates, records amendments, merges; does no role work | all | the operator's review | filled by one session so far (finding F11) |

The tool `conform` is the mechanical part of every gate; the judge
**role** is the agent that writes hidden cases and classifies failures.

### People

Letters as used since Sprint 706 (`access-tiers.md`). "Operator" is not
one of them: here it means the person directing the project.

| Person | Who | In a shaping pass | Human gates held |
|---|---|---|---|
| **O, owner** | the business owner; holds the account and hosts the app; the only approver | settles the open questions of a spec change; keeps or rejects candidates; decides what is served | **both**: the spec review, and consent for the business's machines |
| **A, account member** | an employee with a login and no machine in the mesh | says in plain words what is needed or what went wrong; tries the result | none |
| **C, contractor** | a member with a machine in the mesh and the shaping scope | has their agent build in a work copy and carry out steps that need more skill or access, within scope and band | none in the business case; a candidate from C stays a candidate until O keeps it |

The two gates, stated once:

- **Gate 1, what the app is.** The owner reviews every spec change before
  it is built: open questions, features, acceptance lines (stage 1).
- **Gate 2, that it runs here.** Before the first build, install or run on
  a machine, the person who answers for it consents (stage 6; at stage 3 or
  4 when the build happens on that machine). In the business case that is
  the owner (findings §4a, §4b).

Rules that already hold and stay (findings §4b): one served version, on the
owner's line; a member's change is a verified candidate until the owner
approves it; each member's scope (edit or shape) is recorded with the app;
a candidate never raises the effect cap. How an A's plain-words request
becomes a spec change is the issue-to-spec step of Sprint 730.

## 6. Hidden cases when there is no reference app yet

A spec from instructions has no app to certify against, and an existing
app is a weak judge of it (finding F7). The standard:

1. **The judge role writes the cases from the spec alone,** as a binding
   of a vendor other than the spec author's and the builders'. Each case
   varies only documented behaviour, creates its own state and runs alone
   (soundness criterion 6, the format §20; kb runbook
   `spec-to-source-drill`, A.2). A case that needs a value the spec leaves
   open is not written; the open value goes back to the owner.
2. **The first build that passes the visible contract becomes the
   reference candidate.** Until then, builds are judged by the visible
   contract only, and the result says so (an engineering run, the format
   §19). The owner keeps or rejects that build like any candidate.
3. **The cases are then frozen against the reference:** the reference
   passes them 3/3 and the empty workspace fails them. A case that fails
   the reference is either outside the documented behaviour (fix or drop
   the case) or shows a spec gap (back to stage 1). Then the reference is
   certified (`conform cert`, `conform mutate`), and the hidden-set digest
   is fixed in the drill protocol before any scored run.
4. **The cases are kept private by the owner** (for this project, the
   private docs repository). Only their digests are published. They
   qualify builders and are never shipped with the spec.

*`form`:* hidden set v2 (9 independent cases, `fd7755b171a79511`) was
written by the conductor against an existing reference. One case varied a
secret name the spec gave only by example; it failed one builder run, was
classified as a spec gap, and spec v2.1 documented the rule
(`sprint-723-report.md`, "Failures by cause"). *State: not yet proven:* no
hidden set has been written before its reference, nor by an agent judge.

## 7. Where records live

### Per app: in the spec folder, versioned with it

| Record | Where | Written by | Read by | State |
|---|---|---|---|---|
| Behaviour and acceptance | `CONTRACT.md`, `features.yaml`, `examples/` | spec author; owner approves | builders, the judge | in use on `form` |
| Lifecycle with effects and bands | `dag.md` (`Effects:`, `Band:`) | spec author; bands from drills only | operator agents, the consent gate, lint | in use; `form` bands are `none` or `unmeasured` |
| Effect cap | `contract.bsh` | spec author; owner approves | verifier, consent gate | in use |
| Known issues | `SKILL.md` "Known issues" | any agent proposes; owner keeps | agents in use | in use (`form` KI-1) |
| Measured minimum band | `SKILL.md` `metadata.min-band` | from the builder drill only | the run block's Build intent, routing | `form` carries an unmeasured `L2` |
| Agent-usability seal | `qa.json` (the format §18) | the QA runner only | lint, users | not built |
| Release class | computed on demand, never stored | `release-class.bsh` | owner, consent gate | defined |

### Per spec version: outside the folder

- **Public:** the drill protocol and report with the certification
  evidence and hidden-set digests, in `docs/` (as for Sprint 723).
- **Private:** hidden cases, grader, raw grades and session logs, in the
  owner's private store (here, the private docs repository).

### Per binding

A qualification record per binding, role and spec version, dated, expiring
when the binding, the format or the judge changes (qualification process),
belongs in the bashy agent registry as band evidence; the routing rule (the
cheapest binding whose band meets the spec's measured `min-band`) reads it.
*State: not built* (gap W6): registry bands are seeded or `unmeasured`, and
the Sprint 723 results exist only in its report.

**Per approval:** consent and override records from gate 2 are required
(findings §4a); where they are kept is not decided here (§12).

## 8. How an app enters

Both paths end in the same loop (§3, stages 3 to 8); they differ in where
the spec comes from and what certifies it.

### An existing app: the reverse step (lift)

1. **Spec from the app** (stage 1): kb runbook `shapeware-lift-app`,
   steps 1 to 8; assertions come from real runs on the app.
2. **Compile** (stage 2): `conform spec check` reports nothing.
3. **Owner review** (gate 1): the owner accepts the spec as what the app
   is; where the app departs from its documentation, the difference is a
   known issue (same runbook, "What the first conversion taught").
4. **Certify against the app** (stage 5): `conform cert` and `conform
   mutate` on a test host (same runbook, step 10). The app is the reference.
5. **Hidden cases** against that reference (§6, steps 3 and 4).
6. **Then the loop:** builders rebuild it (stage 3), and so on.

*Before a builder is asked:* a lint-clean spec the owner has reviewed, a
certified reference with every mutant killed, a frozen hidden set whose
digest is in a drill protocol, and a stated venue (kb runbook
`spec-to-source-drill`, part A). *State: partly proven.* Every step but
the owner review ran on `form`, with the conductor as spec author and judge
(`sprint-723-report.md`, "Limits"); no agent has written such a spec or its
hidden cases yet (Sprint 726).

### A new app: the instructions step

1. **Spec from instructions** (stage 1): kb runbook
   `shapeware-spec-from-plan`; everything `tbd`, open values listed.
2. **Compile** (stage 2).
3. **Owner review** (gate 1): every open question is settled.
4. **First build** (stage 3) against the visible contract only, an
   engineering run (§6, step 2). The first passing build that the owner
   keeps becomes the reference.
5. **Hidden cases and certification** (§6, steps 1 and 3): from here on
   the app is an existing app and follows the loop.

*Before a builder is asked:* a lint-clean spec with no open question left,
a stated venue, and consent where it builds (gate 2); with no reference,
the first build qualifies no one. *State: not yet proven:* steps 1 and 2
ran once (findings §1); steps 3 to 5 never (story `e130889b`).

## 9. The dogfood order

Each wave is its own sprint with its own plan (the umbrella's mass-change
rule). Every app below exists, so each wave uses the reverse step (§8).

| Wave | Apps | Entry condition |
|---|---|---|
| 0 | `form` (Sprint 731) | a certified spec (v2.1, `handoff-sprint-731.md`): met |
| 1 | one second app, agents in every role (Sprint 726; `notepad` recommended, plan decision 1) | this standard reviewed (W3), plan decisions 1 to 3 made, the runner leak fix (`6afd1714`) merged |
| 2 | the remaining desk apps: `chart`, `page`, `viewer` | wave 1 met its acceptance with no conductor-written spec or case, and its runbook fixes are merged |
| 3 and on | the other bashy examples (about 50), a few at a time, grouped by kind | the previous wave closed, and the wave's plan names its apps, bindings and quota budget |

At bashy `dc49998c`, `chart`, `notepad`, `page` and `viewer` have a `dag.md`
and an effect cap but no `SKILL.md` or `CONTRACT.md`. **`kit` is a
library** and needs its own decision, as do `gallery` (screenshots) and
`evidence` (round-trip results), which hold no app source; not decided here.

## 10. How a new tool or model joins

**The drill.** A new binding qualifies as a builder through the builder
drill (kb runbook `spec-to-source-drill`, part B: quota check, probe, three
runs, a gate per batch) on each certified spec with a frozen hidden set.
Today that is `form`, whose hidden set is fixed for spec v2
(`spec2src-protocol-v2.md`); a drill on v2.1 first needs a protocol fixing
its digest. Qualified at 2 of 3 or better; one ladder step gives a bound.

**The cost.** Three scored runs per binding and spec, plus one probe. In
Sprint 723 a passing session took 302 s to 1846 s: about 5 minutes for
`claude-sonnet5.5` and `codex-gpt6.1-terra`, 16 to 22 for
`agy-gemini4-carbon`, one `muse-ember` run at the 30-minute cap
(`sprint-723-report.md`, "Every run"); grading time was not reported.
**Quota, not time, is the limit:** probes, worker sessions and scored runs
share one plan quota per binding (F10); one vendor's plan allows about one
drill per reset window beside normal work (`plan-reverse-sdlc-workflow.md`,
"Budget, venue and risks"). A refusal is a venue fault, rerun after the
reset (§2, rule 7).

**The record.** Today a row per binding in a public report (k of 3,
session times, classified failures, digests), raw grades in the private
store; the reader should be the routing rule (§7, "Per binding"). *Not
built:* the registry record (W6), a quota check before runs (W7), the
drill as registered commands (W4). *Not yet proven:* intake for the other
roles: the judge drill (`6e6632d8`) and the spec-author drill (Sprint 726,
`e130889b`) have not run; the operate drill is story T2.

## 11. Open items for the operator review (story W3)

Recommendations only; the operator decides. No sprint or story is changed.

| Item | Options | Recommended | Why |
|---|---|---|---|
| Sprint 726, the loop on a second app | confirm; reshape R1 into an owner review of a Sprint 727 notepad spec; fold into 731; leave in backlog | **confirm** as wave 1, reverse step as filed, after W3 | it measures the unmeasured roles on the one proven path; the reshape would mix in the unproven instructions path, which an existing app judges weakly (F7) |
| Forward test of the three notepad specs (`e130889b`) | confirm as written; reshape; fold into 726; leave in backlog | **reshape** into the first run of the instructions path (§8), its own sprint after wave 1 | as written it builds with no owner review, which gate 1 requires before any build |
| Judge study (`6e6632d8`) | confirm; reshape; fold into 726; leave in backlog | **leave in backlog** until 726 closes, then reshape to use 726's evidence too | the plan places judge qualification after iteration 2 ("Later, in order"); 726 gives the first agent-judge classifications to score |
| Sprint 723 carry-overs: the Google step down, the Zhipu start tier | confirm as a sprint; fold into 726; leave in backlog | **leave in backlog** and run each as an intake drill (§10) when a reset window is free | the goal is a proof of concept, not a census (`handoff-sprint-731.md`, rulings); four vendors already passed |
| Sprint 730, the field loop | confirm; reshape; leave in backlog | **leave in backlog** until wave 1 closes; at confirmation, point its acceptance at this standard instead of Sprint 728 | it needs the install and run stages measured (T2) and the gates of §5; running it beside 726 doubles the conductor load (F11) |

## 12. Deliberately not in this first standard

- **From §8 to §11:** the judge and spec-author drills as standing intake,
  the decision on `kit`, `gallery` and `evidence`, and a census of every
  vendor's lowest tier.
- **The dry run**, **rules as data** with critical rules in the trusted
  core, the **vault-backed secret check**, the **venue preflight**, and
  **the consent gate as one step** with its log (findings §4a). The rules
  are in §2 and §5; the tools are not built.
- **The field loop** (Sprint 730); **the composite band formula and
  routing** (Sprint 559; this standard only requires measured bands); **the
  agent-usability seal** `qa.json` and its runner (the format §18).
- **Drill operations:** registered drill commands (W4), loop-host and venue
  parity (W5), quota management (W7; F10), token and cost accounting (W8);
  the drill runbook covers running one by hand.
- **Judge qualification**, the page interaction inside the judge, signing
  and provenance (the format §9), and group-shaping mechanics (Sprint 709,
  used as they are).
- **Any change to an app's behaviour, the shell interpreter or coreutils,
  and any release.**
