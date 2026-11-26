# Handoff: Sprint 731 (shapeware workflow standard, proven by the full trip on form)

*2026-11-26, from the conductor that ran Sprints 723, 725, 727 and 729 and
started 731. A warm handoff by operator order; the stories were triaged
again just before it.*

## Start here (reading order)

1. The 731 card (`bashy sprint show 731`): goal, acceptance and thread.
2. `docs/plan-reverse-sdlc-workflow.md`, section "The full trip": the stage
   table, where end-to-end tests belong, the ruling that the lifecycle is
   part of the spec, and stories T1 to T4.
3. `docs/shapeware-workflow-findings-2026-11-26.md`: findings F1 to F12,
   the eight questions the standard answers, the tooling ideas (4a) and
   group shaping (4b).
4. `docs/sprint-723-report.md` and `docs/spec2src-protocol-v2.md`
   (amendments 1 to 6): what was measured on `form` and under which
   conditions.
5. kb runbooks in `docs/kb/pages`: `spec-to-source-drill` (how a drill is
   set up and run, with the traps), `shapeware-spec-from-app`,
   `shapeware-spec-from-plan`, `shapeware-source-from-spec`, and the retro
   `shapeware-drill-retro-sprints-722-725`.
6. `docs/shapeware-spec-v0.md` §5a (lifecycle), §7 (effect cap), §12
   (release class).

## Operator rulings in force

- **Goal:** one written workflow standard, with `form` taken the whole way
  as its proof. KISS and MVP; shaping is iterative and no pass is expected
  to be perfect.
- **No separate pipeline.** The lifecycle (`dag.md`) is part of the spec.
  Each step states its effects and a minimum band. A stated band is a
  measured band.
- **A spec is compiled before it is built:** lint now, a dry run later.
- **End-to-end tests are the spec's contract.** They run on the build and
  again against the installed app.
- **Two human gates:** the owner approves what the app is; a person
  consents before it runs on their machines.
- **Letters:** A is an account member, O is the owner, C is a contractor.
  "Operator" means the person directing the project.
- **Install on a machine without bashy** means a launcher on the PATH (the
  previous conductor's default; the operator did not object).
- **Proof of concept, not a census:** some chosen models succeeding is the
  goal, not the lowest tier of every vendor. A quota refusal is a venue
  fault; defer and revisit.

## Stories, triaged 2026-11-26

Work in this order. The two tracks are independent and can run in
parallel.

**Track 1, the trip on `form` (critical path):**

| # | Story | State and what to do |
|---|---|---|
| 1 | Runner leak bug `6afd1714` (agent-bench, p0) | Open. Root cause first, from the Sprint 723 runner logs; then the fix and a test. It must land before any new drill, because the operate drill has subjects start services on purpose. A good first worker story. |
| 2 | T1 lifecycle in the spec `a9e27a3d` (p0) | Partly done: the lint rules are merged (conform `1be6b39`), and `form`'s own `dag.md` has band lines (see "In flight"). Still to do: (a) write the spec-only `dag.md` that the builder is handed, with steps that run without bashy at the venue (build, test with `conform run`, install as a launcher on the PATH, run, serve); (b) add it to the fixture with a new `TASK.md` and digests (agent-bench `packs/spec2src/t1-form`); (c) make the private grader also check at the venue that build, test and run work; (d) 3 runs with one builder that passed (`codex-gpt6.1-terra` is the cheapest that was 3 of 3). |
| 3 | T2 operate drill `22ae0904` (p0) | Open; needs 1 and 2. A new small pack task: a low-band binding takes one passing T1 folder, cold, through build, test, install, one CLI command, serve, fetch the page, stop. Graded by exit codes and by the contract against the installed app. Protocol note before runs; probe each binding; check quota. |
| 4 | T3 record the measured bands `38582fce` (p1) | After 3. Into `dag.md` and `SKILL.md`, as bounds. |
| 5 | T4 report and operate runbook `98f5050d` (p1) | After 3. |

**Track 2, the standard (documents):**

| # | Story | State and what to do |
|---|---|---|
| 6 | W1 the workflow standard `c61a0ec7` (p0) | Ready to assign now: the story note is a complete brief (inputs, the eight questions, rules for the writing, delivery rules). A top-tier binding; review it against the findings before merging. |
| 7 | W2 entry paths, dogfood order, intake `a97079f7` (p2) | After W1. It also decides what happens to Sprint 726 and the two unsprinted stories. |
| 8 | W3 operator review `95f4a97a` (p1) | Last. Then file the next execution sprint. |

## In flight, kept by the previous conductor

**Do not edit these three files until the previous conductor says they
are committed:** bashy `examples/desk/form/CONTRACT.md`, `features.yaml`
and `dag.md`. They hold the secret-name rule fix (assertions F-14 to F-16,
"Spec v2.1") and the band lines. They are uncommitted while the reference
re-certifies on gate lane 2: the certification passed 17 of 17 with no
noisy assertion, and the mutant run was still going at handoff. The
previous conductor commits them, bumps the umbrella pin and closes Sprint
729, then posts on the 731 thread. If the mutant run fails, that is
reported there instead.

## Mechanics and traps

- **Drill scripts are public now:** agent-bench `packs/spec2src/venue/`
  (`env.sh`, `probe.sh`, `run.sh`, `guard.sb.template`). They need
  `S2S_HOME`, a private drill directory. The Sprint 723 one is the
  conductor's private evidence directory on the dev box (`s723/`); it
  holds the frozen adapter cache, the subject's `conform` binary, the
  guard and all run records. `run.sh` has not yet been run from its
  public location.
- **The private grader** is in the private docs repository,
  `docs/conform/form-hidden-v2` (grader v2.1). Its README has the venue
  notes and digests.
- **Reap after every batch,** by workspace path, until bug `6afd1714` is
  fixed.
- **Arms use a plain system shell** (the scripts set it). The installed
  bashy on the dev box can be older than source.
- **Quota:** probes, worker sessions and scored runs share one plan quota
  per binding. Google and Zhipu ran out during Sprint 723. Do not give a
  drill-related worker story to a binding that is a subject.
- **Workers that delivered well:** `codex-gpt6.2-astra` (three bounded
  code stories, about 3 to 10 minutes each, all passed the lane gate
  unchanged) and `agy-gemini4-carbon` (one). Give exact rules, fixtures and
  acceptance in the story; commit and push the story before assigning;
  assign attached, in the background, with stdin closed; gate on a lane at
  the worker's commit, then fast-forward.
- **Never build or test on the dev box.** Gate lane only. On the lane, pin
  tools by absolute path (its base PATH has an older system bashy), and
  move binaries off it as base64.
- **Commits in shared checkouts:** by pathspec only. Other sessions have
  uncommitted files in the umbrella (Sprint 654 stories) and worktrees in
  bashy; leave them.
- **Lease:** export the sprint lease token before sprint commands, or they
  are logged as a bypass; retake the lease when it goes stale.

## Held resources

- **Gate lane 2** is claimed by the previous conductor for the
  re-certification. It is released when the in-flight item above is done;
  take it then, or use lane 3.
- No worktrees or branches are held for 731. One salvage ref in bashy
  (`refs/salvage/abandoned-145`) keeps an unrelated one-line change on
  purpose.

## Backlog outside 731

- Sprint 726: the loop on a second app (`notepad`). Three specs written
  from its original stories exist in the Sprint 727 private directory;
  reshaping its first story into an owner review of one of them was
  proposed and not decided.
- Sprint 730: issues to spec, one issues feed, the guarded field loop.
- Unsprinted: the notepad forward test (`e130889b`), the judge study
  (`6e6632d8`).
