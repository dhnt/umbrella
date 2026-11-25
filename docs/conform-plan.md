# dhnt/conform: the shaping certification suite (plan)

Status: plan for a backlog sprint, written 2026-11-25. Operator review is
required before any story starts. Nothing here is implemented yet.

## Why (the actual gap)

Shapeware spec section 19 (proposed v0.2) makes shaping a certification
process: an app counts as built or shaped only when it passes a fixed suite
under a declared scope, with sealed evidence. That suite has to be an
invariant. No app may change it, and builders, shapers and graders must all
run the same tools.

Today the pieces are scattered or missing:

- a contract runner exists only as a prototype in agent-bench's Python grader
  (Sprint 721 pilot P2);
- the DOM walk lives in `bashy browser extract`, with no shared server-side or
  in-page form;
- noise baselines, mutation checks and sealed evidence records exist only in
  the POSIX certification harness, which is private and licensed.

## Decision

Create a public Go module, `github.com/dhnt/conform` (operator, 2026-11-25),
mounted in the umbrella as a flat submodule.

Dependency direction (one way only):

- conform imports no app, no bashy package and no yoke command package;
- bashy imports conform and ships it as the invariant behind a front door;
- agent-bench graders and app `checks/` call conform through bashy.

## Scope

1. **Contract:** a `CONTRACT.md` parser and runner. Each assertion is numbered
   and has one line of prose, a console block (`$ command`, then the expected
   output) and an exit code. Placeholders bind consistently across steps;
   `--json` output is compared structurally; plain text is checked only where
   given. Results are reported by assertion name as PASS, FAIL or
   INCONCLUSIVE.
2. **Normalization:** id, time and port scrubbing to numbered placeholders,
   and per-path rules (ordered list or set) declared in the contract.
3. **Walker:** one DOM-inventory algorithm (fields, labels, kinds, required,
   options, buttons, visibility) as a Go HTML walk and a JS asset for the
   in-page probe. `bashy browser extract` and the desk kit reuse it.
4. **Certification run:** a reference-vs-reference noise baseline, a mutation
   harness that measures suite strength, a per-layer verdict combined with
   AND, and a sealed evidence record (identities; each result marked fresh or
   reused).
5. **Schemas:** the conformance statement and the documented-freedoms list.

## Non-goals

- No new framework or rewrite of bashy's test DAG.
- No visual or pixel scoring as a verdict (diagnostic only).
- No licensed POSIX material and no private harness code.
- No change to how the POSIX certification itself runs.

## Affected repositories

- **dhnt/conform:** new.
- **bashy:** front-door verb or extension of an existing verb (decide in
  story 1: `bashy dag` or `bashy shape verify` before any new verb); embed the
  walker asset; desk kit probe.
- **agent-bench:** `packs/shapeware` graders call conform instead of the
  Python prototype.
- **umbrella:** new submodule, CLAUDE.md layout list, `script/sync.sh`
  module list.
- **yoke:** none expected (`bashy browser extract` may move its walk to
  conform; decide in story 3).

## Stories (bounded)

1. Repo and module skeleton, the CLI front-door decision, CI = `go test` + vet.
2. Contract parser and runner, ported from the Sprint 721 prototype with its
   fixtures as tests.
3. Walker (Go and JS) with a parity test between them; `bashy browser
   extract` uses it.
4. Noise baseline, mutation harness, verdict, and sealed evidence record.
5. bashy integration (ships the invariant); agent-bench switches to it; the
   prototype is removed (no duplicate path).
6. Contracts for `form` and `viewer` recorded from their reference builds.

## Dependencies

- The Sprint 721 pilot measurement settles the contract format and scoring
  first.
- Spec section 19 stays "proposed" until that evidence exists.

## Acceptance

- Stories 2–4 have their own unit tests; the mutation harness kills every
  seeded mutant of the `form` reference.
- The `form` contract passes on the reference and on the Sprint 721
  shapeware build, reported by assertion name.
- bashy builds with `GOWORK=off` against a published conform version.
- Test host: the gate host lanes; nothing heavy on the dev box.

## Budget

Agy workers (Gemini bindings) for stories 1–6; the conductor reviews and
gates. Cheap-L3 cross-vendor runs only after story 6, per Sprint 721's matrix.

## Risks

- Freezing the format too early: mitigated by waiting for the pilot.
- A second runner surviving next to the prototype: story 5 removes it.
- Walker drift between Go and JS: story 3's parity test.

## Rollback

conform is additive. Until story 5 lands, every consumer keeps working
without it; reverting story 5 restores the prototype path.
