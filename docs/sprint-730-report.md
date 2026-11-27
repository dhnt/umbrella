# Sprint 730 report: the field shaping loop

Sprint UUID: `84e490e9-6cc4-55f2-befb-36c1ba042c5b`. Plan:
`docs/sprint-730-master-execution-plan.md`. Conductor: claude-opus5.5.
Started 2026-11-26 about 3:30 PM PST; delivered the same day about 5:15 PM PST.

## Result

A runtime error and an issue feed now start the existing shaping workflow
unattended. The work is bounded, logged and can be switched off. It is proven on
`form` by a sandbox e2e with fakes that passes on a gate lane.

| Goal | Story | Worker | Delivered |
|---|---|---|---|
| F1 | `452e49fa0f20` | codex-gpt6.2-astra | yoke `892a1149`: `Source{Kind, Ref}` on every wish and candidate; one fence helper that escapes the closing marker, used by the wish, context and repair briefs; feed-origin todos can be wished |
| F2 | `fedd3166a7c9` | agy-gemini4-hydrogen | yoke `2b10346c`: `todo add --reporter/--origin/--id`; bashy `5592aff0`: the `shape-feed` skill-script (GitHub label or JSON file, owner-only, source-derived id, preview by default), registered on the defaults list |
| F3 | `37fd86c8a8cb` | claude-fable5.2 | yoke `8514373c`: the host bound wins over `shaped.json`, a wall-time bound per incident, an off switch, one decision log and a logged override; bashy `df1ea12f`: `bashy shape auto off\|on\|status\|log` |
| F3b | `ab9cbdd6f838` | claude-fable5.2 | yoke `1ae2290c`: feed and schedule wishes obey the off switch and write the log; bashy `6ed6e512`: `shape wish --source`, and `shape-feed` approves what it shaped |
| F4 | `fa2cb2dd82a1` | muse-wonder | bashy `tests/field-loop-e2e` and the dag target `test-field-loop-e2e` |

The conductor added three product fixes, all found by the e2e: `shape-feed
--agent` (an unattended wish needs a shaping agent); approving a `ready`
candidate (`shape wish` returns `ready`, and `shape approve` verifies again
before it activates); and the note on which todo store the feed uses.

Activation policy (operator, 2026-11-26): every unattended source activates a
verified change automatically, with the existing active/previous rollback. The
owner is notified and can undo it.

Heads at close: yoke `1ae2290c`, bashy `9cae0c5b`, umbrella pins `5210ab416`.

## Evidence

All builds and tests ran on lane 3 of the Linux gate host, claimed for this
sprint. None ran on the dev box.

- yoke `pkg/shape/...` and `pkg/webconsole` passed after every merge (F1, F3,
  F2, F3b); `pkg/todo` and `pkg/issue` passed for F2.
- bashy: the build, `internal/agentos` (`TestShape|TestSrc`),
  `examples/shape-feed` and `examples/defaults` passed at `3f9a6910`.
  `examples/shape-feed` passed again at `9cae0c5b`.
- Field-loop e2e: PASS at bashy `9cae0c5b` with 21 checks in about 1.5 minutes.
  It used a fake shaping agent, a JSON issues file, no network and no browser.
  - (a) An incident reported to a loopback console is repaired and activated.
    The decision log shows trigger, attempt, verdict and activation, and the
    previous revision is restorable.
  - (b) An owner's issue becomes a todo (origin `feed`, with the reporter),
    then a wish, and is activated. A non-owner's issue is skipped.
  - (c) The feed runs from `bashy schedule`. After `shape auto off`, the next
    scheduled run files nothing and the log records the switch.

  Raw log: `field-loop-20261126T170957.log` in the conductor's evidence store.

## Findings

1. **Incident repair needs the console.** A local `bashy shape incident` records
   the report but does not repair; only a console has the delegate, verifier and
   activator. The e2e therefore serves the console on loopback and reports the
   incident on the page's own route. This is existing behaviour.
2. **A new shaped app cannot be auto-healed until it has a shared base
   release.** Activation refused with "patch release needs an existing base
   release", and a release private to one principal is not seen by the console
   operator. Filed as `0924f59ba807`.
3. **The todo store and the shape tracker diverge outside a git repo.** `bashy
   todo add` writes the steward list, while `shape wish --todo` looks in the
   caller's own list. Inside a repo both use `docs/todo/`. The feed runs from an
   operations repo; filed as `4d5fda30dfe1`.
4. **A feed run refused while the switch is off writes no log line.** The log
   shows the switch; a wish that reaches the service while off is refused and
   logged. Filed as `6e9a252bb6a6` (future input).
5. **The e2e harness needed 15 fixes on the lane.** Desk siblings, Go caches,
   JSON parsing, the console route, the base release, the operator principal,
   command registration, the store, and `--json` placement. A harness written
   without access to the venue is a draft; plan a lane loop for e2e stories.
6. **Pin bumps.** `bashy mod sync` covers only go.work modules. The nested
   adapter modules and the `src_mount.go` pin were bumped by hand (todo
   `8006b239`). The public module proxy had not yet indexed a nested-module
   version minutes after the push; `GOPROXY=direct` resolved it.
7. **Lane script defect.** `FETCH_HEAD` is per worktree. Fetching in the main
   checkout and checking out `FETCH_HEAD` in a linked worktree left the tree on
   the old commit, so one test run was invalid and was redone.

## Not in this MVP

A spend cap; the spec-method stories (`fce48cc11515`, `74240b60a085`,
`43074ef074ea`, `b7be89cac2d2`, now in Sprint 734); failure capture outside the
console; the skill adapt loop; `critical` in code; the `candidate.bsh` digest
gap (`c61c6d33f114`). Turning on a real GitHub feed is deferred by the operator
(2026-11-26) to the classgo/lern setup, where the repository and label will be
chosen. No release and no hosted deploy.
