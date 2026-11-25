# Sprint 722 Phase B protocol: does the spec reproduce the app?

*Status: fixed before any run (2026-11-25). Changes after the first scored
run are recorded below under "Amendments", with a reason, and apply only to
later batches.*

## Question

Given only the spec of bashy's `examples/desk/form` (its `CONTRACT.md`,
`SKILL.md` and `features.yaml`, no source), does a cheap L3 agent write a
`form` app that conform judges behaviourally equivalent to the reference?

The claim is narrow: "observed across these runs, for these exact models and
this configuration". Not a universal claim about vendors or about agents.

## Subjects

The cheapest L3 binding per vendor, exact bindings recorded per run:
`claude-sonnet5`, `codex-gpt6-luna`, `agy-gemini3.8-flash`, `muse-spark1.2`,
`opencode-glm-5.3-flash`. n = 3 per subject, 15 scored runs.

None of these bindings works on conform or on the form contract during
Phase A, so no subject has seen the judge's code or its hidden cases.

## Primary outcome (per run)

**PASS** when conform's verdict, combined with AND, is PASS on all three
layers:

1. the visible CLI contract (`CONTRACT.md`, by assertion name);
2. the hidden CLI cases (parameterized variants of the visible assertions:
   other ids, values, field kinds and step orders);
3. the UI layer: DOM inventory equal to the reference's, plus the scripted
   interactions (fill, submit, read back through the CLI) and direct JSON
   API checks.

Assertions that the reference-vs-reference noise baseline marks as noisy are
excluded from the verdict and listed. Otherwise FAIL or INCONCLUSIVE.

Per subject, the result is k/3 PASS. No aggregate across vendors is a primary
result.

## Secondary measures

- Per-assertion pass rate, visible vs hidden. A large visible-hidden gap is
  reported as overfitting to the examples.
- Per-layer verdicts (CLI, hidden, UI).
- Shapeware-layout compliance, reported separately and never part of PASS.

## Accounting (recorded for every attempt, including failures)

- wall time (agent start to agent end) and grader time;
- tokens in/out and cost as reported by the tool; unknown is recorded as
  unknown, never estimated;
- agent-visible tool calls, and underlying commands where the tool log shows
  them;
- retries, crashes and human interventions (the target is zero; any
  intervention is recorded and makes the run non-confirmatory).

A cheap failure never improves a subject's efficiency figures: cost per PASS
is reported next to cost per run.

## Conditions (identical for every run)

- the same task prompt, byte-identical, with its sha256 in the record;
- a fresh, isolated workspace containing only the three spec files and the
  task prompt; the same venue image, toolchains and permissions; no network
  except the local Go module proxy;
- a wall-time cap of 30 minutes (it fits the agy 40-minute session limit);
- run order randomized within each batch; the seed is recorded.

## Venue and deliverable (added 2026-11-25, before any run)

- **Agent sessions run on the dev box.** That's where the subjects' CLIs and
  logins live, and every sprint worker uses the same route. Each session gets
  its own fresh workspace through the agent-bench runner (`bashy chat --agent`,
  same budget and idle rules for every subject).
- **Grading runs only on the gate host lane**: Linux x86_64 with Go 1.27,
  Python 3.12, Node 18, POSIX sh, curl and jq. There is no network, no bashy
  on the candidate's PATH, and a headless browser stub (`xdg-open` records the
  URL and exits 0).
- **The deliverable is source.** It has to include an executable POSIX-sh
  launcher, `./form`, at the workspace root that builds or runs the app on
  that Linux venue, compiling on first use if it needs to. Dependencies must
  be standard library only or vendored in the workspace. A binary built on the
  dev box is not run.
- The workspace starts with `CONTRACT.md`, `SKILL.md`, `features.yaml`,
  `examples/contact.json` (used by the contract) and `TASK.md`, which states
  the deliverable and the venue above, word for word the same for every
  subject.

## Integrity

- The grader, the hidden cases and the expected results stay outside the
  agent's reach. The hidden cases are kept in the private docs repository
  (`dhnt/docs`), not in conform or agent-bench, and are copied to the grader
  venue only after the agent ends.
- At agent end, the workspace is snapshotted and hashed. conform grades the
  snapshot in a separate sandbox, never the live workspace.
- Reading the public spec is legitimate. Hard-coding its examples shows up
  as a visible-hidden gap.

## Controls

- **Reference:** the reference build is graded 3 times. This is the noise
  baseline, and it must PASS every time.
- **Suite strength:** every seeded mutant of the reference, including UI
  mutants, must be killed before any subject run.
- **Null candidate:** an empty workspace must FAIL.

## Classification and reruns

- A harness or venue failure (the grader crashed, the venue broke, a model
  quota ran out before the first agent turn) is INCONCLUSIVE-venue. Only
  that cell reruns, and both attempts are kept.
- Anything the agent did or failed to do is a FAIL for that run, never a
  rerun.
- Classification uses the recorded evidence and is made before the outcome
  of the cell is looked at, where possible.

## Batches

1. **Smoke**, not scored: one run of one subject, to freeze the harness.
   Its results stay outside the confirmatory set.
2. **Batch 1:** one run per subject (5). Gate: review the INCONCLUSIVE-venue
   cases and fix the venue only.
3. **Batches 2 and 3:** one run per subject each. The harness is frozen
   after the smoke run; venue fixes are recorded as amendments.

## Reporting

A bashy viewer book (`sprint-722`) with:

- this protocol;
- a per-run table (subject, binding, run, verdict per layer, accounting);
- per-subject k/3 results;
- the controls;
- notable failures by assertion name;
- the narrow conclusion.

## Amendments

(none)
