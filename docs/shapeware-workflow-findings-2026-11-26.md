# Findings for planning the shapeware workflow (Sprints 722 to 727)

*Written 2026-11-26 as the input material for Sprint 728, which plans the
complete shapeware workflow and its standard processes. It records what was
measured, what it implies, and the questions the plan must answer. It is not
the plan.*

Principle from the operator (2026-11-26): **shapeware is iterative
shaping.** Nothing here expects a perfect app from one pass. The workflow
has to make each pass cheap, checkable and safe to repeat.

## 1. What was measured

### Spec to source (Sprint 722, then 723, on `form`)

| Condition | Result |
|---|---|
| Spec v1, each vendor's cheapest model, no judge in the loop | 1 pass in 15 runs |
| Spec v2, middle tiers, the judge in the loop | `codex-gpt6.2-sol` 3/3; `muse-spark1.3` 3/3; `claude-sonnet5.5` 1/3, then 3/3 after a harness fix; `agy-gemini4-carbon` 1/3, reruns cut short by quota |
| Same, one tier down | `codex-gpt6.1-terra` 3/3; `muse-ember` 3/3; `claude-sonnet5` 2/2 with one run outstanding at the time of writing |

Every pass is complete: all visible assertions, all hidden cases, the page
inventory and a real page interaction. Protocol and amendments:
`spec2src-protocol-v2.md`.

### Instructions to spec (Sprint 727, on the Sprint 537 notepad stories)

Three top-tier bindings (`claude-opus5.5`, `codex-gpt6.2-astra`,
`muse-wonder`), one session each, no access to the app's source.

- Each wrote a spec in 3 to 7 minutes: 9 to 15 features, 34 to 43
  assertions, all features marked not yet built, with Decisions and Open
  questions sections. All three pass `conform spec check`.
- Run against the existing notepad app, the contracts pass 3 to 8
  assertions as written. One guessed value (a note's first status) fails
  the first assertion and unbinds the rest. With only that value left
  open, 40 to 47 percent pass.
- The three specs name the same things differently (the content field,
  error codes, a remove verb).

## 2. Findings

| # | Finding | Evidence |
|---|---|---|
| F1 | **The spec decides the outcome more than the model tier does.** The same task went from 1 of 15 to consistent passes after the spec was made sound, and tiers one step down then passed too. | 722 versus 723 |
| F2 | **A judge the builder can run is part of the product.** Builders ran it several times per session and fixed by assertion name. | session logs, 723 |
| F3 | **Failures classify cleanly by cause** (spec gap, agent defect, judge defect, venue fault), and the classification is what improves the spec. | the seven gaps of 722 produced spec v2 |
| F4 | **Most surprises were venue faults, not model limits:** a cached host binary, an unstated runner cutoff, an agent shell that hid the judge, signed-out arms, quota refusals. Each looked like a model failure until the evidence was read. | amendments 1 to 4; kb retro |
| F5 | **Cascades hide real quality.** One wrong value or one missing format failed everything that depended on it, in hidden cases (722) and in contracts (727). | 722 amendment 4; 727 results |
| F6 | **Instructions to spec is fast and structurally sound, but not deterministic.** Three converters produced three valid, different specs. | 727 |
| F7 | **An existing app is a weak judge of a spec written from instructions.** The stories never fixed output shapes, and the app departs from its own stories in places. | 727 |
| F8 | **The open-questions list works when used.** Two of three converters named the very guess that broke their contract. | 727 notes |
| F9 | **Bounded stories with exact rules and fixtures delegate well.** Two worker stories were delivered in about 10 minutes each and passed the lane gate unchanged. | 723 S7, 725 |
| F10 | **Quota, not time, limits a drill.** Two vendors ran out in one night; probes, worker sessions and scored runs share one plan quota. | 723 |
| F11 | **The conductor is a bottleneck and a single point of bias.** The spec, the hidden cases and every classification on `form` were written by one session. | 723 disclosures |
| F12 | **Nothing measured yet feeds a decision automatically.** No qualification record, no measured minimum band on a spec, no routing. | plan gaps W6 |

## 3. What the findings imply for the workflow

1. **The spec review is the human gate.** Since converters differ (F6)
   and guess (F8), the owner settles the open questions before anything is
   built. This is the one place a person is required.
2. **The first passing build becomes the reference.** A spec from
   instructions cannot be certified against an app that does not exist or
   does not match (F7). After the first pass, certification and mutation
   apply.
3. **Each pass is small and judged.** A shaping pass changes a few
   features, the judge says which assertions pass, and failures are
   classified (F2, F3). "Verified with tbd" is a normal state, not a
   defect.
4. **Specs and cases are written to fail independently** (F5): open values
   where the instructions are silent, fixed ids where possible, one case
   per behaviour.
5. **Venue conditions are part of the standard** (F4): the shell, the
   snapshot rule, runner limits and the stated venue are fixed and written
   down, and a refusal is never scored as a failure.
6. **Roles are filled by different bindings and recorded** (F11, F12):
   spec author, judge, builder, with the owner reviewing and a conductor
   only gating.
7. **Quota is budgeted like a venue resource** (F10).

## 4. Questions the plan must answer

1. **The stages and their gates, end to end.** A first sketch:
   instructions → spec draft → owner review of open questions → spec
   check → first build → judge → reference certified → release as spec →
   field shaping passes → known issues and tbd features → next version.
   Which gates are mechanical, which need a person, and what evidence each
   leaves.
2. **What counts as done for one shaping pass,** given that no pass is
   expected to be perfect: the release classes of the spec format (§12),
   or something simpler.
3. **Who may fill each role,** at which band, and how a binding earns it
   (the drills) without the conductor writing the material.
4. **How hidden cases are produced** when there is no reference app yet,
   and who keeps them.
5. **Where records live:** per app (the measured minimum band, the seal of
   D23) and per binding (qualification), and what reads them.
6. **How an existing bashy app enters the workflow** (reverse step) versus
   a new one (instructions step), and the order in which bashy's apps are
   dogfooded.
7. **How a new tool or model joins:** which drills, on which sealed specs,
   and what it costs in quota.
8. **What is deliberately left out of the first standard.**

## 4a. Tooling ideas recorded for the plan (operator, 2026-11-26)

bashy should carry the tooling that helps agents succeed at shaping.

- **Lint, for both roles** (done in Sprint 729): `conform spec check` flags
  a rule given by example, and `conform run` tells a builder when the spec
  it is building from has findings.
- **Rules as data, critical rules as trusted core** (not built): a rule
  every implementation must apply the same way ships with the spec as a
  normative data file; a feature marked `critical` is supplied, not
  rebuilt (`shapeware-spec-v0.md` §5).
- **Validate against the real environment, not only the text** (a thought,
  not built): where a spec or a request refers to something in the
  environment, bashy can check it before work proceeds and say what is
  wrong. Two cases: a secret check that asks the vault (a field whose name
  is a stored secret's name, or whose value is a stored secret, is
  refused, whatever it is called); and a venue preflight (the tools,
  versions, variables and ports a spec names exist where it will run).
  Most of the surprises in finding F4 were of the second kind.

  Constraints agreed with the operator for the secret check: it runs with
  the caller's own access and never elevates, so it compares only against
  secrets the caller could already read and adds no way to probe others;
  it answers yes or no without naming the secret; it never logs or stores
  the value; and where the caller has no vault access it says "not
  checked" and the name rule still applies.
- **A dry run of a spec or a skill** (a thought, not built): walk it
  without executing anything and report what would happen. For a contract:
  the order of the steps, which later assertions depend on a value bound
  by an earlier one (so a single point that would cascade is visible, as
  in finding F5), which commands, example files and tools each step needs
  and whether they exist. For a skill-script: its steps and declared
  effects. bashy already has `--dry-run` as a common option and a static
  script preflight (`bashy check`); this would extend the same idea to
  specs.

- **A consent gate on the user's machine** (operator, 2026-11-26; not
  built as one step). A spec shipped as an application is built and run on
  the user's own infrastructure by the user's agent, so a person decides
  before that happens. The format already has the parts: the effect cap
  declared in `contract.bsh` (§7; no cap means read-only and not
  field-built), the computed release class (§12; fail closed), and the
  rule that a candidate can never raise the cap. What the workflow needs
  is one gate that puts them in front of the user: what this spec will do
  here (effects, paths, ports, tools; from the dry run), its lint
  warnings, its release class and its measured minimum band, then an
  explicit yes before the first build or run. Later shaping passes inside
  the approved cap do not ask again; anything beyond it does. Every
  approval and every override is logged. With the spec review on the
  author's side, this makes two human gates: the owner approves what the
  app is, and the user approves that it runs here.
- **The framing: a spec is compiled before it is built** (operator,
  2026-11-26). The spec is the source. Lint and dry run are the compile
  step: they report errors and warnings in seconds, with no model in the
  loop, before any agent spends a session. The agent's build is code
  generation, and the judge is the test run. The plan should name these
  stages in those terms and decide which findings are errors (block the
  build) and which are warnings.

## 4b. Group shaping on one artifact (operator, 2026-11-26)

With the lifecycle inside the spec, a team shapes a feature by working on
one artifact, the spec folder, instead of handing work between a
development side and an operations side. The typical business case
(`access-tiers.md`; Sprints 706 and 709), described here by role:

The letters, as used since Sprint 706 and confirmed 2026-11-26:
**A** is an **account** member (an employee with a login and no machine
in the mesh), **O** is the **owner** (the business owner, who hosts the
app and is the only approver), **C** is a **contractor** (a member with a
machine in the mesh and the shaping scope). "Operator" is not one of the
three; in this repository it means the person directing the project.

| Person | Role in the team | What they do in a shaping pass | What the spec gives them |
|---|---|---|---|
| The business owner | holds the account, hosts the app, the only approver | settles the open questions of a spec change; approves what is kept and served; gives consent for what runs on the business's machines | the release class, the effect cap and the band per step, in one place to approve |
| An office employee | uses the app every day; no machine of their own in the mesh | says what is needed or what went wrong, in plain words; this becomes an issue and then a spec change; tries the result | features and known issues in words they can read; acceptance lines that say what "works" means |
| A tech support contractor | has a machine in the mesh and the shaping scope | has their agent build the change in a work copy and carry out the lifecycle steps that need more skill or access | `dag.md`: exact steps, the effects and the least agent each step needs |

Rules that already hold and stay: one served version, on the owner's
line; a member's change is a verified candidate until the owner approves;
scope per member (edit or shape) is recorded with the app; a candidate
never raises the effect cap.

What the plan should add: which of the two human gates each person
holds (the owner holds both), which steps a member's agent may run by
band and by scope, and how an employee's plain-words request reaches the
spec (the issue-to-spec step of Sprint 730).

## 5. Material

- Plans: `plan-spec2src-calibration.md`, `plan-reverse-sdlc-workflow.md`
  (gaps W1 to W8; Sprint 726, the four-story loop on a second app, is in
  backlog and is the first candidate for execution).
- Process and format: `shapeware-qualification-process.md`,
  `shapeware-spec-v0.md` (§5, §12, §18 to §20).
- Protocols: `conform-phase-b-protocol.md`, `spec2src-protocol-v2.md`.
- kb runbooks: `spec-to-source-drill`, `shapeware-spec-from-app`,
  `shapeware-spec-from-plan`, `shapeware-source-from-spec`; retro
  `shapeware-drill-retro-sprints-722-725`.
- Tools: `dhnt/conform` (run, cert, mutate, spec check), agent-bench
  `packs/spec2src` with `venue/`.
- Open stories: the forward test of the three notepad specs (a builder
  builds from each and is judged by that spec's own contract); the
  deferred judge study; the Sprint 723 carry-overs (Google reruns, the
  Zhipu start tier).
