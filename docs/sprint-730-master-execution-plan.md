# Sprint 730: the field shaping loop

Sprint UUID: `84e490e9-6cc4-55f2-befb-36c1ba042c5b`. Epic: software-shaping.
Status: backlog, planning only. No coding until the operator says so (2026-11-26).
Origin: `docs/plan-reverse-sdlc-workflow.md`, section "The field loop". This
document replaces that section as the sprint's plan. Written 2026-11-26 from an
independent review that re-read the code and the format.

Sprint 732 (shared shaping ledger) waits on this sprint, and Sprint 733
(ClassGo pilot) waits on 732.

## Primary goal

An issue (bug, new feature, missing feature) has a defined place in a shapeware
spec, and one app handles issues from one designated feed and its own runtime
failures through a guarded shaping pass that the owner approves.

## Review (2026-11-26)

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

## What exists

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

## Gaps

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

## Design

**One route, owner at the end.** Feed issue or captured incident → todo item →
the L1 runbook writes the spec change → the owner reviews the spec change →
`shape wish --todo` or the Build intent in a work copy → graded by the installed
`candidate.bsh` and conform on a claimed gate lane → offered → the owner
approves or rejects. Incident repair's automatic activation is not used by the
loop; capture runs in record-only mode.

**Issue records are todo items.** The id is derived from the source
(repository and issue number), so a re-read does not duplicate. Provenance is
kept on the record. The feed is GitHub issues with one owner-chosen label, read
through a fixed read call. Because the record is a todo item, it is already the
problem key Sprint 732's ledger uses.

**The feed never authorizes.** Reading an issue creates a record and nothing
else. The loop acts only on records the owner has accepted. Issue text is
passed to agents as fenced data with the closing marker escaped.

**The guard is a property of the host, not the app.** The host's bounds win
over the app's `shaped.json`. The loop runs under an identity that can file a
wish and cannot approve. One switch stops it. Every action and decision is
appended to one log.

**Format decisions are made once.** L0 settles the six points and amends the
spec. Sprint 734 cites the result.

## Stories and triage

| # | Story | Pri | Size | Repos | Depends on |
|---|---|---|---|---|---|
| L0 `fce48cc11515` | Decide the spec format points the field loop depends on | p0 | S | umbrella docs | none |
| L1 `74240b60a085` | kb runbook `shapeware-issue-to-spec` | p0 | M | umbrella kb, bashy kb | L0 |
| L5 `37fd86c8a8cb` | Guard for unattended shaping | p0 | L | yoke, bashy | none |
| L2 `43074ef074ea` | `conform spec check` rules for known issues and `tbd` features | p1 | M | conform | L0 |
| L6 `b7be89cac2d2` | `conform cert`: fail on the old reference, pass on the fixed one | p1 | M | conform | L0 |
| L3 `fedd3166a7c9` | One read-only issues feed into issue records | p1 | S-M | yoke, bashy | none |
| L4 `fa2cb2dd82a1` | The loop on `form`: one bug and one `tbd` feature | p1 | L | bashy, form | L0, L1, L3, L5, L6 |

Triage decisions:

- **L0 is new and first.** L1, L2 and L6 would otherwise be written against
  guesses.
- **L6 is new.** The bug-fix rule needs a judge change, not only lint. Sprint
  734 names the same rule; this sprint owns it.
- **L4 drops its dependency on `55730ebaf952`** and uses `shape wish` with a
  separate owner approval. Runtime failures enter through console incident
  capture in record-only mode. A hook for terminal runs is out of scope.
- **L5 grew.** Beyond the listed points it must stop self-approval on the
  routes the loop touches, make the host's bounds win, add a bound per issue,
  fence issue text, close the core-digest gap in `candidate.bsh`, and add the
  off switch, the decision log and the override path.
- **L2 starts with a `SKILL.md` input and a known-issue parser.** The `tbd`
  acceptance rule is a warning unless L0 changes the format.
- **L3 reuses** `sdlc mirror` and the `meet adopt` pattern. GitHub label is the
  recommended source; the chat route is not.
- **Boundary with Sprint 734.** This sprint owns the issue-to-spec runbook, the
  known-issue, `tbd` and `critical` lint rules, and the expected-fail cert
  mode. Sprint 734 owns the other generic lint and runbook fixes. Both edit
  `conform/spec/check.go`, its README and the shapeware kb pages, so they run
  in sequence, not in parallel.
- **Smallest useful cut: L0, L1, L2.** Issues have a defined, checked place in a
  spec, applied by hand. L5, L3, L6 and L4 add the unattended loop.

## Sequence

Nothing starts until the operator says so.

1. L0, with the owner.
2. L1, L2 and L6 after L0. L5 and L3 can run beside them; they share no files.
3. L4 last, on integrated heads, first attended, then unattended once L5 is
   accepted.

Changes that span repos merge yoke first, then `bashy mod sync` with the bashy
change, then the umbrella gitlinks. conform changes need a bashy pin bump.

## Checks

- L0: the amended spec sections are reviewed by the owner; `form` and `notepad`
  still pass `conform spec check`.
- L1: the runbook is applied to `form` KI-1 and `group-required`, and to one
  notepad known issue, by an agent that did not write it.
- L2 and L6: unit tests and fixtures in conform, run on a gate lane.
- L3: a re-read of the feed creates no duplicate; a record carries the reporter;
  no command runs from reading.
- L5: unit tests that a passing repair is not activated when the loop is the
  caller, that the host's bound wins over `shaped.json`, that the off switch
  stops a running loop, and that a closing marker inside issue text does not
  end the fence.
- Acceptance (L4): on `form`, one bug and one `tbd` feature go from the feed, or
  from a captured runtime failure, to an offered, judged change that the owner
  approves. A failure leaves a known-issue entry with what was tried. Builds
  and tests run on a claimed gate lane, never the dev box.
- No release and no hosted deploy.

## Decisions for the operator

1. The six format points in L0.
2. The feed source: GitHub issues with one label (recommended), and which
   repository and label.
3. Severities for the L2 rules (proposed on the card).
4. Whether incident repair's automatic activation stays as it is for apps
   outside the loop, or becomes opt-in everywhere.
5. Order against Sprint 734.

## Risks

- A public issue is untrusted text aimed at an agent. The feed creates records
  only, the owner accepts them, and the text is fenced.
- An unattended loop can spend without limit: there is no spend cap today. The
  bound per issue and the off switch come before L4 runs unattended.
- Changing how incident repair activates affects apps that rely on it today.
  The loop's rule is scoped to the loop unless the operator decides otherwise.
- New format fields are additive, so existing specs keep passing.
