# Plan: spec → source calibration (a sound shapeware spec, and the minimal model)

*Status: backlog plan, written 2026-11-25 from the Sprint 722 results.
Operator review is required before any story starts.*

This is the first iteration of the standing process in
`docs/shapeware-qualification-process.md`: spec creation, plus agent
qualification for the builder, judge and spec-author roles. Sprint 723
proves the process on `form`, for the builder and judge roles.

## Objectives

1. **What a sound shapeware spec is.** Turn the gaps that Sprint 722
   measured into checkable rules for a spec. Apply them to `form` (spec v2),
   and show that they remove the spec-attributable failures.
2. **The minimal model per vendor.** For each vendor, find the lowest model
   tier that reproduces the app from spec v2 (PASS in at least 2 of 3 runs,
   judged by conform). Start at the latest middle tier, then step down or
   up.
3. **A shapeware spec checker/validator** (operator, 2026-11-25), so the
   criteria are mechanical, not a reviewer's judgement.
4. **The band an evaluator needs** (operator, 2026-11-25), L4 or L5, to do
   the judge's job done by hand after Sprint 722: classify every failure by
   cause, find judge defects, and derive the spec gaps.
5. **A bashy kb runbook, then a skill,** for the whole recipe, so the next
   drill is run from the recipe rather than rediscovered.

## Evidence: Sprint 722 failure classification

15 scored runs (cheapest L3 per vendor × 3), judged with conform v0.1.1.
Each non-pass is classified by its cause: **S** = spec gap, **A** = agent
defect, **J** = judge. Two J defects were fixed in v0.1.1, and neither
changed a verdict.

| # | Spec gap (S) | Runs hit | Evidence |
|---|---|---|---|
| G1 | **An input format stated but never demonstrated.** "JSON or YAML" appears only in prose, and no YAML example or acceptance line exists. Under a stdlib-only rule, 7 apps silently supported JSON only, and 1 hand-wrote a parser that misses flow lists `[a, b]`. | 8 | H-01: "invalid definition JSON", "definition must be valid JSON", "kind choice needs at least one option" |
| G2 | **`--fields` is never defined.** It appears only in examples. The undefined points are that it projects the output to the named keys, that it works on every verb (`add`, `show`, `open`, `answer`, `wait`), and that `schema_version` is always kept. | 4 | claude b2 (`--fields` ignored on add: extra `ownerKey`), claude b3 (projection dropped `schema_version`), codex b2 (`--fields` rejected on `show`), codex b3 (`--fields` ignored on `show`) |
| G3 | **Open vs closed outputs are implicit.** The contract marks open fields with `"..."`, but create outputs (F-07 poll) are closed with no stated reason, so harmless extra keys fail. Where closed is load-bearing (F-02 must not expose definition or answers), the reason is stated. | 3 | F-07: extra `inviteURL` (codex b3, muse b3), `close_at`/`respondents` (agy b1) |
| G4 | **The page has no behavioural acceptance line.** The only visible page check is `GET /?id=… => 200 data-field="name"` plus the U-01 inventory. Nothing demonstrates "a person fills the page, submits, and the CLI reads `answered`". | 4 | HI-01: after a page submit, the CLI still reads `pending` or empty answers (codex b1, b2; claude b2; agy b3) |
| G5 | **The accessibility rules sit in one bullet.** U-01 judges the *accessible* inventory, but the rules are not stated as requirements: programmatic labels (`<label for>` / `fieldset`+`legend`), one control per field, `required` marked, and option labels distinct from the field label. | 5 | an unlinked label (agy b1), a duplicate control (agy b2), `required` missing (codex b2), the field label bound to the first option (codex b3), 0 fields rendered for a second form (agy b3) |
| G6 | **Definition shapes are shown, not described.** `--def FILE` takes `{title, fields}`, and `--definition JSON` takes a bare array of fields (seen only in F-06). | 1 | codex b1: "cannot unmarshal array into … struct { Title …" |
| G7 | **`SKILL.md` mixes the behaviour spec with how bashy operates the reference.** It covers `form.bsh`, `dag.md`, `server/`, the KI-1 workaround and verbs outside the contract (`ask`, `share`, `join`, `serve`). That is noise for a reproduction and was not measured. | — | n/a |

**Agent defects (A), not fixable by the spec:** a nil-map crash on
`answer` (codex b1); no delivery after long model turns (opencode b1, b2).
A self-check loop might catch the first; see conform-in-the-loop below.

**Expected effect of G1–G6** on the same 15 runs: 5 more would very
likely pass (G1 + G3 alone), up to 8 if G4/G5 also land. This is an
estimate from the failure classes, not a measurement.

## Soundness criteria for a shapeware spec (proposed; spec section 20)

A spec is **sound for reproduction** when:

1. **Every requirement is demonstrable.** Each stated behaviour has at least
   one example in `CONTRACT.md` or an acceptance line in `features.yaml`.
   Prose alone is not a requirement. (G1, G4)
2. **Every input format has a worked example** in the spec folder, covering
   the syntax actually used (for YAML: block and flow lists). (G1, G6)
3. **The output envelope rules are stated once:** always-present keys
   (`schema_version`), projection (`--fields`), and open vs closed per
   output, with the reason where closed is load-bearing (privacy). (G2, G3)
4. **UI requirements are checkable rules, not inferences:** the accessible
   inventory rules, plus at least one page-interaction acceptance line
   (fill, submit, then CLI read-back). (G4, G5)
5. **The behaviour spec is separate from reference operations.** `SKILL.md`
   (agent-facing operation) and the reproduction spec do not leak
   reference-only artifacts into requirements. (G7)
6. **Hidden cases vary only documented behaviour,** and each is independent
   (no case depends on another's state). This is a property of the grader,
   recorded with the spec.

A small `conform lint` (story S7) checks criteria 1–3 mechanically: prose
features without acceptance lines, formats without examples, and outputs
without an open/closed marker.

## Conditions (changes from Sprint 722)

- **Spec v2** (S2) replaces v1. The reference must still certify: PASS,
  0 noisy, every mutant killed.
- **Hidden cases v2** (S3): the same documented behaviours, each case
  independent, the interaction on its own JSON form, and one independent
  YAML case. Digests are fixed before any run.
- **conform in the loop:** the agent's PATH has a standalone `conform`
  binary (v0.1.1+, no bashy), and `TASK.md` says "you may run
  `conform run CONTRACT.md` against your build". The agent sees only the
  visible contract. This is the intended product condition (spec §19: the
  suite ships with bashy and agents use it while building).
- **Unchanged:** the 30-minute cap, n = 3, a fresh isolated workspace, the
  sandbox guard, the Keychain opt-ins, auto-update off, grading only on the
  gate lane, the frozen grader, and amendments recorded before the affected
  runs.

## The model ladder

Bands from the bashy model registry: L3 cheapest, L4 middle, L5 top.

**Every registry band is seeded, not measured** (`band_source: seeded`). For
example, all muse models are seeded at the same placeholder cost.

Meta's own docs (checked 2026-11-25) give the order. Ember is the
high-volume, cheapest model ($0.10 / $0.50 per 1M tokens). Spark 1.3 is
"mid-tier" ($1.25 / $4.25). Wonder is the "highest capability" model
($4 / $20). Wonder Full sits above it on plans only. Meta maps
haiku → ember, sonnet → spark and opus → wonder. The Sprint 722 Meta
subject, spark1.2, was therefore an older **mid-tier** model, not a cheap
one. The start
tiers below therefore follow each vendor's product naming:

- Anthropic: haiku, sonnet, opus;
- Meta: spark, then ember / wonder;
- Zhipu: flash vs full;
- Google: flash vs gemini4 tiers;
- OpenAI: luna, sol, astra.

This drill's results are the first **measured** tier evidence per binding,
and they feed the bands, as the qualification process prescribes.

**The step order uses a price prior** (operator, 2026-11-25). Within one
vendor, the registry `cost_micro` rank plus generation recency orders the
family, newest first at equal price:

- OpenAI: luna 3k < terra 9k < sol 18k < astra 24k;
- Google: 3.8-flash 1.2k < hydrogen 4.5k < neon 9k ≈ carbon 10k;
- Anthropic: sonnet 6k < opus 15k < fable 30k;
- Zhipu: flash 0.5k < glm 0.9k.

Meta's registry prices are flat placeholders (5k each). Meta follows its list prices: ember < spark < wonder.

| Vendor | Start (latest L4) | Step down (L3) | Step up |
|---|---|---|---|
| Anthropic | claude-sonnet5.5 | claude-sonnet5 | claude opus5.5, then fable5.2 (priced 2x opus) |
| OpenAI | codex gpt6.2-sol | codex gpt6.1-terra, then gpt6-luna | codex gpt6.2-astra |
| Google | agy gemini4-carbon | agy gemini4-neon (priced near carbon), then gemini4-hydrogen, then gemini3.8-flash | none listed |
| Meta | muse-spark1.3 (Meta: "mid-tier") | muse-ember (Meta: high-volume, cheapest) | muse-wonder, then wonder-full |
| Zhipu | opencode glm-5.3 | opencode glm-5.3-flash | none listed |

**Rule.** Run the start tier × 3.

- If it passes in ≥ 2 of 3 runs, run the step-down tier × 3.
- If it passes in ≤ 1 of 3, run the step-up tier × 3 where one exists.

A vendor's **minimal tier** is the lowest tier with ≥ 2 of 3. When no
listed tier reaches that, it is reported as "not reached". Smaller samples
are reported as observations, not estimates. A step-down rerun of an L3
model from Sprint 722 is a new measurement (spec v2 and conform in the
loop), not a comparison.

**Budget.** 15 start runs plus at most 15 step runs, plus 8 evaluator runs
(S9). These are
subscription-plan seats; nothing paid by usage is used without the
operator. About 30 minutes per batch of 5 in parallel.

## Stories (bounded)

1. **S1 Gap catalogue and soundness criteria.** This document, plus
   shapeware spec section 20 (proposed). Conductor.
2. **S2 Form spec v2** (bashy `examples/desk/form`): G1–G7.
   - Add `examples/contact.yaml` with an acceptance line, a `--fields` rule,
     open markers on create outputs, a definition-shapes section, UI rules
     and a page-interaction acceptance line, and a behaviour/operation
     split in `SKILL.md`.
   - Re-certify the reference on the lane: cert ×3, mutate (UI mutants
     included).
3. **S3 Hidden cases v2** (private, dhnt/docs): independent cases, the
   interaction on its own form, one YAML case. Reference 3/3, null fails,
   and digests in the protocol.
4. **S4 Harness:** a standalone `conform` on the agent PATH (guard-allowed),
   `TASK.md` v2, re-frozen adapters, a protocol v2 doc fixed before runs,
   and an unscored smoke with a non-subject agent.
5. **S5 Start batch:** the latest L4 per vendor × 3, in random order.
6. **S6 Step batch:** down or up per vendor, using the rule above.
7. **S7 Spec validator** (`conform spec check DIR`), in two parts:
   - **Static:** criteria 1–3. Prose features with no acceptance line,
     declared formats with no worked example, outputs with no open/closed
     marker, and `--json` outputs missing an always-present key.
   - **Dynamic:** reuses `cert` and `mutate` (the reference certifies,
     every mutant is killed), plus a hidden-case independence check (each
     case runs alone in a fresh HOME). The grader passes the hidden case
     directory in.

   Acceptance: on spec v1 it flags G1–G3, and on spec v2 it is clean.
8. **S9 Judge-band study (L4 vs L5).**
   - **Pack:** one evidence pack from Sprint 722, with no conclusions in it:
     the spec v1 files, the 15 snapshots' raw per-assertion grades, the
     rendered pages, the session logs, and the conform source.
   - **Task** (fixed prompt): classify every non-pass as a spec gap, an
     agent defect or a judge defect; name any judge defects with a repro;
     list the spec gaps.
   - **Evaluators:** the latest L4 and L5 binding of two vendors (for
     example claude-sonnet5.5 vs opus5.5, and codex gpt6.2-sol vs
     gpt6.2-astra), n = 2 each.
   - **Reference set:** this sprint's catalogue, frozen before the
     evaluators run, plus an independent second L5 classification;
     disagreements are adjudicated and recorded.
   - **Scoring:** agreement on the item labels; detection of the two known
     judge defects (the lone checkbox, the yes/no select); the YAML cause
     split (no parser, partial parser, not YAML); no invented causes.
   - **Result:** the lowest band that matches the reference set at a stated
     threshold, fixed before the runs.
9. **S10 kb runbook, then a skill-script:** `bashy kb` page
   `spec-to-source-drill`, covering:
   - protocol first, then the harness;
   - the arm traps (Keychain opt-ins, the adapter cache, auto-update);
   - the sandbox guard;
   - grading only on the lane (netns, xdg-open stub);
   - batches and gates;
   - the judge audit (render the failing pages);
   - the ladder and the report.

   Then a skill-script that runs the mechanical steps (probe, batch,
   gate, regrade, table).
10. **S8 Report:** a viewer book with the minimal tier per vendor, the
   criteria validated or refuted, and limitations.

## Decisions needed from the operator before S2

- **D1 YAML:** keep YAML as a requirement (add the example and acceptance
   line; recommended, since it is a real use and the reference supports
   it), or declare "JSON only".
- **D2 Extra keys on create outputs:** allow them (mark `"..."`;
   recommended where harmless), or keep them closed and say so. Closed stays
   wherever it protects content, as in F-02.
- **D3 conform in the loop as the standard condition** (recommended), or
  also run an ablation without it (+15 runs).
- **D4 Judge-band threshold** for S9, for example ≥ 90 % label agreement
  and both judge defects found.

## Non-goals

- No change to bashy's `form` behaviour; only its spec files change.
- No paid-API models without the operator. No new apps beyond `form`.

## Risks

- **Hidden v2 changes the grader,** so v1 and v2 results are not directly
  comparable. Mitigation: the report keys every result to its grader digest.
- **Quota or sign-in failures in the arm** (the Keychain trap): probe each
  binding in a real arm before the batch.
- **Ladder depth is limited** where a vendor lists no higher tier.

## Master execution plan (takeover, 2026-11-26)

Written at the conductor takeover, from a review of the card, this plan,
the handoff (`docs/handoff-sprint-723.md`) and the current source. It
applies the operator's MVP ruling of 2026-11-25; where it differs from the
story list above, this section wins.

**Code inspected (2026-11-26).** The umbrella bashy pin equals the bashy
origin head and contains spec v2 (bashy 44c4d966, with
`examples/contact.yaml`). conform is at v0.1.1 on its origin head. The
private `form-hidden-v2` directory does not exist yet. The Sprint 722
scripts and the sandbox guard are present. No weaves are held; gate lane 2
is claimed for this sprint.

| Phase | Work | Owner | Venue | Exit gate |
|---|---|---|---|---|
| 0 | Take the lease and lane 2; align the card with the MVP ruling | conductor | dev box | card acceptance matches the ruling |
| 1a | S3 hidden cases v2 (private): one form per case, the page interaction on a JSON form, one YAML case with block and flow lists | conductor (no subject binding sees it) | gate lane 2 | reference 3/3, null FAIL, digests recorded |
| 1b | S4 harness v2: standalone `conform` on the agent PATH, `TASK.md` v2, re-frozen adapters, protocol v2 | conductor | gate lane 2 | one unscored smoke with a non-subject binding passes the full chain |
| 1c | S7 validator, static criteria 1–3 only | one worker, isolated workspace on conform | gate lane 2 for tests | flags G1–G3 on spec v1, clean on spec v2 |
| 2 | Freeze: protocol v2 with grader digests, ladder, rule and random seed; probe every subject binding in a real arm | conductor | dev box arms | all probes green; no change after this point |
| 3 | S5 start batch: each vendor's start tier × 3, 30-minute cap, batches in parallel | conductor | arms on the dev box, grading on gate lane 2 | every run graded; every non-pass classified S, A or J |
| 4 | S6 step batch: one step per vendor (down at ≥ 2/3, up at ≤ 1/3) × 3 | conductor | same | every run graded and classified |
| 5 | S8 short report (viewer book keyed to the grader digest); runbooks S10, S12, S13 written from what was done | conductor; S12/S13 drafts by a worker | dev box | book renders; kb pages registered |
| 6 | Release the lane, checkpoint, close on the MVP acceptance | conductor | — | card closed, or carried with reasons |

**Changes from the story list above.**

- **S7 runs before the freeze (phase 1c), static only.** Its acceptance is
  "clean on spec v2". A flag raised after the ladder would change the spec
  and void the runs. The dynamic part is deferred.
- **S6 is one step.** A pass at a step-down tier is reported as "passes at
  this tier; lower tiers untested", not as the vendor's minimum. A failed
  start with no listed step-up is reported as "not reached".
- **S9 (judge study) is not required to close 723.** It stays on the card
  at p3 and runs only after the builder half, if the box allows; otherwise
  it carries to the next iteration.
- **S10 is the runbook only.** The skill-script is deferred.

**Stop rules.**

- A venue fault voids the whole batch. The fix is recorded as a protocol
  amendment before the rerun.
- A new judge defect pauses the ladder until conform is fixed and the
  reference re-certifies.
- A quota refusal on a worker switches model, then vendor. A subject
  binding is never substituted.

**Open with the operator.**

- The Zhipu bindings (`glm-5.3`, `glm-5.3-flash`) are registered with
  usage-priced access. Their runs (up to 6) are held until the operator
  approves them or drops Zhipu from this iteration.
- The conductor session's model is also the last Anthropic step-up
  subject. Grading is mechanical (conform), and protocol v2 records this.
