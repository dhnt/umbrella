# Shapeware specs and agent qualification: the process (proposed)

*Status: proposed process design, written 2026-11-25 from Sprint 722.
Sprint 723 is its first iteration, on bashy's `form` app. Nothing here is
normative until that iteration's evidence exists.*

## Purpose

There are two standing processes, modelled on POSIX certification:

1. **Spec creation.** How a shapeware spec is written, checked, certified
   and published, so that it reproduces its app.
2. **Agent qualification.** How an agentic tool and model binding is
   qualified for a role, with evidence. The roles are *builder* (source
   from a spec), *judge* (evaluate a drill) and *spec author* (write a spec
   for an app).

The two depend on each other:

- A spec is sound only when qualified builders reproduce the app from it.
- A builder is qualified only against sound specs.
- A judge is qualified only against a reference judgement.

The cycle is broken by a fixed bootstrap: one reference app, its certified
spec, frozen hidden cases, and a reference judgement adjudicated by more
than one L5 evaluator.

## Roles and qualifications

| Role | What it must do | Qualification drill | Evidence | Pass rule |
|---|---|---|---|---|
| **Builder** | Write source from a spec alone | spec → source under the drill conditions (fresh workspace, cap, sandbox, lane grading) | conform verdicts on the visible, hidden and UI layers, sealed per run | ≥ 2/3 PASS on each qualifying spec |
| **Judge** | Classify every non-pass as spec gap, agent defect, judge defect or venue; find judge defects with a repro; derive the spec gaps | the judge drill on a conclusion-free evidence pack | the labels and findings against the reference judgement | an agreement threshold, all seeded or known judge defects found, no invented causes |
| **Spec author** | Write a sound spec for an existing app | app → spec | the validator, plus qualified builders reproducing the app from the authored spec | validator clean, and ≥ 2/3 qualified builders reproduce it |

A qualification is recorded **per binding** (tool:model), **per role**
and **per spec version**, with a date. It feeds the agent's band in the
bashy registry: evidence, not a self-report. Qualifications expire when the
binding, the spec format or conform changes in a way that affects the
drill.

## Spec creation process

1. **Author** the spec folder:
   - `CONTRACT.md` (CLI assertions and `ui` assertions);
   - `features.yaml` (intent plus acceptance lines);
   - `SKILL.md` (the behaviour spec; reference operation kept separate);
   - worked examples for every input format.
2. **Validate statically** with `conform spec check`, soundness criteria
   1–3: every requirement is demonstrable, every format has an example,
   output rules are stated, and every output is marked open or closed.
3. **Certify the reference:**
   - `conform cert`: PASS on every layer, 0 noisy across 3 runs;
   - `conform mutate`: every seeded mutant killed, UI mutants included.
4. **Write the hidden cases**, privately. They vary documented behaviour
   only, each case is independent, and the reference passes them 3/3
   while the null workspace fails. Digests are fixed in the drill protocol.
5. **Reproduction check:** qualified builders reproduce the app from the
   spec (the builder drill). If they fail, the failures are classified. A
   spec gap goes back to step 1; a builder defect counts against the
   builder.
6. **Publish** the spec version together with its certification evidence
   and the hidden-case digests (never the hidden content).

## Qualification process (any role)

1. **Protocol before runs:** outcome, accounting, conditions, venue, the
   pass rule, controls, and the rerun rules (venue faults only). Every
   amendment carries a date and a reason.
2. **Harness and venue:**
   - the isolated arm (credentials by recorded opt-in);
   - a sandbox guard that denies reading the reference, hidden cases and
     evidence;
   - grading only on the gate lane (loopback network namespace, no
     builder tooling);
   - one grade at a time where state is shared.
3. **Smoke** with a non-subject agent. Freeze the harness.
4. **Batches** in random order, with a gate between them. Venue faults
   rerun as recorded attempts; agent failures count.
5. **Judge audit** before a verdict is trusted: render the failing pages,
   reproduce suspected judge defects, fix the judge, regrade every snapshot
   identically, and report both results.
6. **Report:** a viewer book with narrow claims (exact bindings, runs,
   versions), plus a private archive of the raw evidence.

## The model ladder (builder and judge)

- **Start** at the vendor's latest middle tier (L4).
- If it passes, **step down**; if it fails, **step up**.
- The **minimal tier** is the lowest one that passes. Where no listed tier
  passes, it is reported as "not reached".

The ladder is per role. The judge band is measured separately from the
builder band.

**A band is a recorded composite** (operator, 2026-11-25), per binding and
per role:

| Component | Source | What it contributes | Scope |
|---|---|---|---|
| **a. Drill** | agent-bench qualification drills (this process; the harness is to be improved) | k/n PASS per role and spec version, sealed evidence | strongest; role-specific |
| **b. Leaderboards** | public leaderboard data relevant to the role (for example coding-agent and terminal-task boards), with source, date and version recorded | a cross-vendor anchor (percentile) | general capability; may lag new models |
| **c. Price rank** | the vendor's list price (registry `cost_micro`, with its source), newest first at equal price | the order within one family | within-vendor only; blind to generation, plans and "fast" pricing |
| **d. Operator weight** | an explicit operator adjustment, with its reason and an expiry | factors the other three miss (reliability, quota, policy) | bounded to ±1 band, always logged |

- **Score** = w_a·a + w_b·b + w_c·c, each component normalized to 0–1. The
  score maps to L1–L5 by fixed thresholds, then d is applied.
- **Initial weights** (arbitrary, recorded, recalibrated once drill evidence
  accumulates): w_a 0.5, w_b 0.3, w_c 0.2. A missing component is left out
  and the others are renormalized. The record lists which components were
  present.
- **`band_source`** records what the band rests on:
  - `seeded`: nothing yet;
  - `price-prior`: c only;
  - `composite:b+c`, `composite:a+b+c` and so on;
  - plus `+d` when an operator weight applies.
- **A drill result (a) for a role always outranks the other components for
  that role.** If a contradicts b or c, the case is recorded as calibration
  evidence for the weights.

## Artifacts

| Artifact | Where |
|---|---|
| The judge (runner, walker, certification, validator) | `github.com/dhnt/conform`, shipped in bashy as `bashy conform` |
| Drill harness (packs) | agent-bench `packs/spec2src` (and a judge pack) |
| Spec format and soundness criteria | `docs/shapeware-spec-v0.md` sections 19 and 20 |
| Recipe | bashy kb runbook `spec-to-source-drill`, then a skill-script |
| Hidden cases, raw grades, archives | private: `dhnt/docs` |
| Qualification records | the bashy agent registry (band evidence) |

## Iterations

1. **Sprint 723** (`form`). Sound-spec criteria and spec v2, the validator,
   the builder ladder from L4, the judge-band study (L4 vs L5), and the kb
   runbook. This proves the process on one app.
2. **Next** (not filed; to be planned after 723):
   - spec-author qualification (app → spec), on `form` and a second app;
   - qualification records wired into bashy agent bands;
   - a second reference app to test that the criteria generalize.
