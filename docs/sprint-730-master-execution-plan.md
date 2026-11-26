# Sprint 730: the field shaping loop

Sprint UUID: `84e490e9-6cc4-55f2-befb-36c1ba042c5b`. Epic: software-shaping.
Status: backlog, planning only. No coding until the operator says so.
Rescoped 2026-11-26 (KISS/MVP, operator ruling). This page replaces the
seven-story plan of the same day; that plan's code findings are kept as an
appendix because they are still true of the code.

Sprint 732 (shared shaping ledger) waits on this sprint, and Sprint 733
(ClassGo pilot) waits on 732.

## Operator ruling (2026-11-26)

The field loop handles a few typical cases:

- (a) an error during use, for example in a web UI or its backend: auto heal,
  auto shaping;
- (b) an issues feed: GitHub issues filed by the owner, a chat channel, or a
  scheduled research agent.

It runs unattended, so that the owner spends less on maintaining an
application. These are not separate flows. They use exactly the same software
shaping workflow. Only the source differs: an agent or a system trigger instead
of a person. Everything after the trigger is reused.

## Primary goal

Runtime errors and designated issue feeds trigger the existing shaping workflow
unattended. The work is bounded, logged and can be switched off. Proven on
`form`.

## What the code already gives

Inspected at yoke `257ce147` and bashy `b5e679bb`.

- **Case (a) already runs on the shaping workflow.** Console incident repair
  records a wish through the shape candidate service
  (`yoke/pkg/webconsole/shaped_candidate.go:484-489`). It verifies with the
  shared verifier (`:914-916`), replays, then activates
  (`shaped_repair.go:157-330`). When a repair runs out of attempts, it becomes
  an ordinary request for the owner to review. `form` qualifies, because it is
  a web app with a declared server.
- **Case (b) has its entry point.** `shape wish APP --todo ID` runs the same
  `shape.Service.Wish` path that a person uses
  (`yoke/pkg/shape/service.go:643-679`). `bashy sdlc mirror` already reads one
  repository's issues by label, and reading twice creates no duplicates.
  `bashy schedule` runs jobs unattended. A scheduled research agent is a
  scheduled job that files a todo or a wish.
- **Gaps that matter only for unattended sources:**
  1. `shape.Wish` carries no source (`service.go:81-93`). Tracking refuses a
     todo whose origin is not empty or `shape` (`shape/tracking.go:89-90`), so
     a feed item cannot be wished.
  2. Issue text is not fenced safely. The text can close the wish brief's fence
     (`shape/helpers.go:98-115`). The repair brief inserts the incident message
     with no fence at all (`shaped_repair.go:141-154`).
  3. The app's `shaped.json` overrides the host's attempt bound and may set it
     to unlimited (`shaped_repair_limit.go:32-40`). There is no time bound per
     item, no global off switch, no single decision log and no override path.
  4. The activation policy depends on the source. Incidents activate
     automatically; wishes stop at verified. Unattended sources need one rule
     (see "Decision for the operator").

## Stories

| # | Story | Repo | Size | Reuses |
|---|---|---|---|---|
| F1 `452e49fa0f20` | Source on the wish. Add `Source{Kind: human, incident, feed or schedule; Ref}` to `shape.Wish` and to the candidate record. Tracking accepts feed origins. One fence helper, which escapes the closing marker, is used by both the wish brief and the repair brief. | yoke | S | `shape.Service.Wish`, `tracking.go`, `helpers.go` |
| F2 `fedd3166a7c9` | Feed to wish, as a skill-script. `bashy shape feed APP --source gh:REPO#LABEL` reads the designated source through a fixed read call. It keeps only items the owner filed or labelled. It files a todo whose id is derived from the source, so a re-read creates no duplicate, and records the reporter. Then it calls `shape wish APP --todo ID`. A chat channel or a research agent uses the same verb with another `--source`, or files the todo itself. `bashy schedule` runs it unattended. Small yoke fix: `todo add --reporter`. | bashy kb/defaults, yoke | S-M | `sdlc mirror`, the `meet adopt` id pattern, `bashy schedule` |
| F3 `37fd86c8a8cb` | One guard for every unattended source, incidents included. The host's bound wins over `shaped.json`. There is a bound on attempts and wall time per item, and one off switch. Each trigger, attempt, verdict and activation appends one line to a single decision log. `--override --reason` is logged. | yoke, bashy | M | incident attempt records, the existing activation with slot rollback |
| F4 `fa2cb2dd82a1` | Proof on `form`, on a claimed gate lane. (a) An injected 5xx heals through the incident path. (b) An issue the owner filed on GitHub goes from the feed to a todo, a wish and verification, then is activated or offered as the policy says. (c) The feed runs once from `bashy schedule`, and the off switch stops it. A failure leaves a known-issue note on the todo that records what was tried. | bashy, form | M | sandbox e2e with fakes, within the minutes budget |

Order: F1, then F2 and F3 in parallel, then F4. Merge yoke first, then
`bashy mod sync` and bashy, then the umbrella gitlinks. Take a claim on each pin
bump and announce it.

**Not in this MVP.** These are recorded here and get no new stories:

- a spend cap;
- the spec-method items (format decisions, the issue-to-spec runbook, the
  known-issue and `tbd` lint, the expected-fail cert mode). They moved to
  Sprint 734's collection as `fce48cc11515`, `74240b60a085`, `43074ef074ea`
  and `b7be89cac2d2`;
- capturing failures from terminal runs, outside the console;
- the skill adapt loop;
- enforcing `critical` in code;
- the `candidate.bsh` digest gap when it runs with no arguments, filed as
  todo `c61c6d33f114`. F3 checks only the console route's protected paths.

## Operator decisions

- **Activation policy (2026-11-26):** one rule for every unattended source.
  When verification and replay pass, the change is activated automatically
  with the existing active/previous rollback, and the owner is notified and
  can undo. This is how incident repair already works.
- **Still open:** the GitHub repository and label that make up `form`'s feed.

## Checks

- F1 to F3: unit tests in yoke and bashy, run on a gate lane. They show that the
  fence survives a closing marker inside the text, that the host's bound wins,
  that the off switch stops a running loop, that a re-read of the feed creates
  no duplicate, and that a todo from the feed can be wished.
- F4: sandbox e2e with fake accounts, finishing in minutes, with evidence
  recorded once on the candidate.
- `bashy mod drift` is clean for yoke and bashy at close.
- No release and no hosted deploy.

## Appendix: code findings from the first review (2026-11-26)

Read at bashy `8e051472`, yoke `bbe744c9` and conform `5148116`. The 2026-11-26
rescope re-checked them at bashy `b5e679bb` and yoke `257ce147`. The later
commits do not touch these files. The findings are kept as code facts. The
remedies they proposed are superseded by the stories above.

### First review

Read at bashy `8e051472`, yoke `bbe744c9` and conform `5148116` (equal to the
bashy pin). The goal stands. Six findings change the stories.

1. **A passing repair already goes live without the owner.** The console
   incident path verifies, replays, activates and releases
   (`yoke/pkg/webconsole/shaped_repair.go:197-201`, `:311-314`). The skill adapt
   loop also applies its fix by itself (`yoke/pkg/skills/adapt.go:196-238`).
   Both contradict "offered, never self-approved". Only `shape wish` followed by
   `shape approve`, and the work-copy route, leave the decision to the owner.
2. **L4's trigger is not built.** Yoke todo `55730ebaf952` (failed trajectory to
   the repair loop) has no code: no `skill repair`, no `--episode`. L4 must not
   wait on it.
3. **The format has no safe place for a bug's failing example.** Under a
   verified feature it prints FAIL and the release class becomes blocked (spec
   §12 rule 1). §4.2 has no field linking a known issue to an example. `form`
   KI-1 has no failing example today.
4. **The judge cannot express the bug-fix rule.** The operator's ruling is that
   a bug-fix assertion must fail on the old reference and pass on the fixed
   one. `conform cert` marks any assertion that fails a reference run as noisy,
   which makes the verdict inconclusive and stops the reference certifying
   (`conform/cert/baseline.go:65-73`, `:105-111`).
5. **The lint does not read known issues.** `conform spec check` never opens
   `SKILL.md`, where known issues live (`conform/spec/check.go:47-210`). One L2
   rule (a `tbd` feature needs an acceptance line) reverses the current lint and
   the format's own default.
6. **Three existing pieces were not named in L3.** `bashy sdlc mirror` (label
   read of GitHub issues, inert by design), the GET-only `gh:` mount in
   `examples/trove`, and `scripts/ci-failure-router.sh` (an unattended
   issue-to-repair loop with an attempt ladder and a pause label).

Smaller corrections:

- Story cards cite spec §7 for the checks contract. §7 is the effect cap; the
  checks contract is §6.
- "Spec v1.0" in notepad is that app's own spec version. The shapeware format is
  still `0.1` for both apps.
- `critical` is data only. No code and no lint reads it.
- `@guard` is a Bash# function decorator, not a guard for a loop.
- The message board is one host-wide board without per-topic reads, and anyone
  on the host can post. It is a weak designated source.
- A terminal run of `form` or its `dag.md` test creates no incident. Runtime
  capture exists only for console-served web apps.

### What exists

- **Format.** Known-issue entries in the `SKILL.md` body (§4.2), the Build
  intent (§4.3: work copy, graded by the installed `checks/candidate.bsh`,
  "offer, never self-approve"), `features.yaml` with `tbd` and `critical` (§5),
  the checks contract (§6), the effect cap (§7), release class (§12).
- **Worked material.** `form` has KI-1 (`SKILL.md:142-147`, todo
  `90a9343b598b`) and the `tbd` feature `group-required`
  (`features.yaml:40-49`). `notepad` has three known issues and a `tbd` feature
  that resolves one of them.
- **Gates.** The owner reviews every spec change before it is built, a shaping
  pass may not change existing assertions or checks, and only the owner
  promotes `tbd` to `verified` (`docs/shapeware-workflow-standard.md:56-57`,
  `:273`, `:310-311`).
- **Entry and approval.** `bashy shape wish APP --todo ID` stops at a verified
  candidate; `shape approve` is separate.
- **Runtime capture.** For console-served web apps, 5xx and start failures
  become incidents with a signature
  (`yoke/pkg/webconsole/shaped_incident_capture.go:129-170`). `form` qualifies.
- **Verify route.** The effect cap is fixed from the base, checks are frozen
  from the base and run contained (`yoke/pkg/shape/verify/verify.go:266-283`).
- **Records.** The todo item already has id, title, body, reporter, origin and
  labels (`yoke/pkg/issue/issue.go:264-344`). `meet adopt` shows the import
  pattern: preview by default, an id derived from the source, provenance kept.
- **Scheduling and lanes.** `bashy schedule` runs jobs unattended; `bashy claim`
  takes a lane lease and an unattended process can hold one.

### Gaps

1. Six format points are undecided (story L0).
2. No runbook takes an issue to a spec change.
3. The lint cannot see known issues, `critical`, or a published marker.
4. The judge has no expected-fail mode for a bug fix.
5. No feed writes issue records; the todo record lacks a reporter flag, and
   shape tracking refuses items with a foreign origin
   (`yoke/pkg/shape/tracking.go:89-90`).
6. Two existing routes self-approve; the host's attempt bound can be overridden
   by the app's `shaped.json`; there is no bound per issue, no spend cap, no
   global off switch, no single decision log and no override path.
7. Issue text reaches an agent brief with a fence that the text can close, and
   the repair brief does not fence it at all.
8. The trusted core is not protected when `candidate.bsh` runs without
   arguments: the clone's server is checked against the clone's own digest.

