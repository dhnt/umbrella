# Sprint 723 protocol v2: the lowest model tier that reproduces `form` from spec v2

*Status: fixed before any scored run (2026-11-26). Changes after the first
scored run are recorded under "Amendments", with a reason, and apply only to
later batches.*

This protocol replaces `conform-phase-b-protocol.md` (Sprint 722) for the
Sprint 723 ladder. Everything not restated here is unchanged from that
document, including its venue traps (amendments 2 and 3).

## Question

Given only spec v2 of bashy's `examples/desk/form`, with the judge's tool in
the loop, which model tier of each vendor writes a `form` app that conform
judges behaviourally equivalent to the reference?

The claim is narrow: "observed across these runs, for these exact bindings
and this configuration".

## Subjects and the ladder

| Vendor | Start | Step down | Step up |
|---|---|---|---|
| Anthropic | `claude-sonnet5.5` | `claude-sonnet5` | `claude-opus5.5` |
| OpenAI | `codex-gpt6.2-sol` | `codex-gpt6.1-terra` | `codex-gpt6.2-astra` |
| Google | `agy-gemini4-carbon` | `agy-gemini4-neon` | none listed |
| Meta | `muse-spark1.3` | `muse-ember` | `muse-wonder` |
| Zhipu | `opencode-glm-5.3` | `opencode-glm-5.3-flash` | none listed |

**Rule.** Each vendor's start binding runs 3 times. Then **one** step:

- PASS in 2 or 3 of the 3 runs: the step-down binding runs 3 times.
- PASS in 0 or 1 of the 3 runs: the step-up binding runs 3 times, where one
  is listed.

**Reporting.** One step gives a bound, not a minimum.

- A step-down that passes 2 of 3 or better is reported as "passes at this
  tier; lower tiers untested".
- A step-down that does not is reported as "the start tier is the lowest
  tier observed to pass".
- A failed start with no listed step-up, or a failed step-up, is reported as
  "not reached".

Per binding, the result is k/3 PASS. No aggregate across vendors is a
primary result. The registry bands of these bindings are seeded, not
measured; these runs are their first measured evidence.

## Primary outcome (per run)

**PASS** when the verdict, combined with AND, is PASS on all three layers:

1. the visible CLI contract (`CONTRACT.md` v2, 13 CLI assertions);
2. the hidden cases v2 (9 cases, 17 CLI steps): the same documented
   behaviours with other ids, values and field sets;
3. the UI layer: the visible page inventory (U-01), the hidden page
   inventory, and one page interaction (fill by label, submit, read back
   through the CLI).

**Every hidden case is independent.** Each creates its own form and runs
alone in a fresh HOME. YAML is exercised by one hidden case only, so a YAML
gap costs one case, not the layer's other checks. This removes the coupling
recorded as amendment 4 of the Sprint 722 protocol. Per-case verdicts are
kept as a secondary measure.

Secondary measures and accounting are unchanged from Sprint 722.

## Conditions (identical for every run)

- The workspace starts with `CONTRACT.md`, `SKILL.md`, `features.yaml`,
  `examples/contact.json`, `examples/contact.yaml` and `TASK.md` (spec v2,
  bashy `44c4d966`; fixture in agent-bench `199eb77`). File digests are in
  the pack's `task.yaml`.
- **conform in the loop.** A standalone `conform` v0.1.1 binary is on the
  subject's PATH, and `TASK.md` says so and gives the command
  (`conform run CONTRACT.md --path . --fresh-home`). The subject sees only
  the visible contract. This is the intended product condition
  (shapeware spec §19).
- **A plain system shell in every arm** (zsh), set by the runner
  (`BASHY_FORCE_AGENT_SHELL=0`, `BENCH_PLAIN_SHELL=1`, agent-bench `09e5826`).
  See "Arm probe result" below for the cause.
- A wall-time cap of 30 minutes; n = 3; a fresh isolated workspace and HOME
  per run; the sandbox guard; the Keychain opt-ins; opencode auto-update
  off; one frozen, read-only adapter cache (58 executables, digests kept
  with the evidence).
- Sessions run on the dev box. Grading runs only on the gate host lane, on
  the snapshot, never on the live workspace.

## Grading venue

Linux x86_64 with Go 1.27, Python 3.12, Node 18, POSIX sh, curl and jq.
No network, no bashy on the candidate's PATH, an `xdg-open` stub, and no Go
module cache (standard library or vendored dependencies only).

Each grading phase (the visible contract, each hidden case, the page
interaction) runs in its own network and process namespace with a fresh
HOME. No state or port is shared between phases, and every process a
candidate leaves behind ends with its namespace. One snapshot is graded at
a time.

## Controls (run before any subject, 2026-11-26)

- **Reference through the full grader:** PASS 3 times out of 3, 33 of 33
  assertions each (14 visible, 18 hidden steps, the interaction).
- **Null candidate** (an empty workspace): FAIL on every layer, 0 of 33.
- **Suite strength on the visible contract v2:** 109 of 109 mutants killed;
  the reference certifies 14/14 with no noisy assertion over 3 runs
  (Sprint 723 S2).

## Grader identity (fixed before runs)

The hidden material is private and identified here only by digest (sha256,
first 16 hex digits):

| Item | Digest |
|---|---|
| hidden set v2 (9 cases, the interaction script, its inputs) | `fd7755b171a79511` |
| visible `CONTRACT.md` (spec v2) | `ae30df1a5d9bf392` |
| conform v0.1.1, grader binary (Linux x86_64) | `3fd12fbdbaacfc15` |
| conform v0.1.1, subject binary (macOS arm64) | `aaab8d7a5005cb02` |

Every grade record carries the hidden-set, contract, conform and snapshot
digests. The digests of the two grader scripts are kept with the private
cases.

## Classification and reruns

Unchanged from Sprint 722: a harness or venue failure is
INCONCLUSIVE-venue, only that cell reruns and both attempts are kept;
anything the agent did or failed to do is a FAIL. In addition:

- A venue fault found at a batch gate is fixed in the venue, recorded as an
  amendment, and the affected cells rerun.
- Every non-pass is classified by cause: spec gap, agent defect or judge
  defect. A failing page is rendered and inspected before a UI FAIL is
  trusted.
- A new judge defect pauses the ladder until conform is fixed and the
  reference re-certifies.

## Batches

1. **Smoke**, not scored: one run of `codex-gpt6-sol`, which is on no
   vendor's ladder, through the full chain. It freezes the harness.
2. **Start batches 1 to 3:** one run per start binding each (5 runs, in
   parallel). Seeds 723001, 723002 and 723003 give the recorded order
   within each batch (Python `random.Random(seed).shuffle` over the table
   order above).
3. **Step batches 4 to 6:** one run per step binding each, seeds 723004 to
   723006, over the bindings the rule selects.

Each subject binding is probed in a real isolated arm before its first
batch (sign-in and quota), without the task.

## Disclosures

- **The conductor.** The conductor session that wrote the hidden cases and
  runs this protocol is a Claude model. Grading is mechanical (conform on
  the gate lane), and failure classification is published per run with its
  evidence. The Sprint 722 gap catalogue and spec v2 were written by a
  Claude conductor too.
- **One subject binding worked on the validator.** `agy-gemini4-carbon`
  was assigned the static spec checker (`conform spec check`) in a separate
  worker session on 2026-11-26. That session saw the visible spec v1 and v2
  and the conform source. It did not see the hidden cases or the grader.
  Subject runs start from a fresh isolated HOME with no state from that
  session. The result for this binding is reported with this note.
- **Spec v2 was written after seeing the Sprint 722 failures.** These runs
  measure spec v2 with conform in the loop; they are new measurements, not
  a comparison with Sprint 722.

## Smoke result (2026-11-26, not scored)

`codex-gpt6-sol` ran the full chain: a 367-second session, a snapshot, and
a 15-second grade on the lane. The subject found `conform` on its PATH and
ran it six times. The harness is frozen from here.

**Limitation recorded from the smoke.** The subject's `conform` runs on the
dev box (macOS, with that host's interpreters), and the judge runs on the
Linux venue that `TASK.md` states. A build can pass in the loop and fail at
the venue: the smoke candidate imported a Python module that is deprecated
in the venue's Python 3.12, and the warning on stderr failed five error
assertions. This is the subject's to handle (the venue is stated), and it
is classified as an agent defect, not a venue fault.

## Arm probe result (2026-11-26, before any scored run)

Each start binding was asked, in a real isolated arm without the task, to
run `conform version` and report it.

- **Venue fault found and fixed.** `bashy chat` routes an agent's shell
  commands through bashy by default, and the operator's Claude settings pin
  the same. In a bashy shell, `conform` is a built-in for bashy's own test
  batteries, so it shadowed the judge binary: the Claude arm could not
  reach the tool `TASK.md` names. The codex smoke was not affected, because
  codex does not take its shell from the environment. Fix, in the venue
  only: every arm now runs a plain system shell. The name clash itself is
  a product gap and is tracked as a bashy todo.
- After the fix, `claude-sonnet5.5`, `codex-gpt6.2-sol`,
  `agy-gemini4-carbon` and `muse-spark1.3` each reported version 0.1.1.
- `opencode-glm-5.3` does not answer a one-shot probe (the 722-proven
  `opencode-glm-5.3-flash` fails the same way, so this is the probe's
  launch mode). Through the runner's interactive launch path it started
  and accepted its instruction. Its first scored batch is the check; a
  launch failure there is INCONCLUSIVE-venue.

## Reporting

A bashy viewer book (`sprint-723`): this protocol, a per-run table keyed to
the grader digests, k/3 per binding, the bound per vendor, the controls,
the classified failures and the limitations.

## Amendments

None yet.
