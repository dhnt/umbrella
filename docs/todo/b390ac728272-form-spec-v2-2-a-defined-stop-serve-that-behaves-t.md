---
id: b390ac728272
kind: task
title: 'form spec v2.2: a defined stop, serve that behaves the same for every build, and the spec''s lifecycle in the spec; rerun build and operate'
seq: 801
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T16:06:19.944136Z
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: Shapeware workflow standard, proven by the full trip on form
---

Operator rulings at the Sprint 731 review (2026-11-26): resolve the serve and stop gap now; a spec is self-contained (design left to the conductor).

## Code inspected and measured (2026-11-26)
- bashy `examples/desk/form` at `4b8cc25f`: `form.bsh` has `stop` (stops the user's server by its recorded process id, exit 0 either way) and `serve` (foreground); `ensure_server` starts a background server on `add`, `ask` and `reply` only.
- Measured on the gate lane with the reference, in one isolated run: `stop` exits 0 and the page stops answering; a second `stop` exits 0; `show` fails while stopped; `serve` then serves the earlier form at the same address; a TERM sent to `serve` ends the launcher with status 143 but the server keeps answering; `add` after a stop starts the server again; a final `stop` stops it.

## Design
1. **The stop is `form stop`, in the contract.** New "Service rules" and assertions F-17 to F-20: stop exits 0; stop again exits 0; `add` after a stop works; a form stored before the stop is still there. What a signal does to `serve` is an implementation freedom, because the reference does not stop on TERM. Starting `serve` while a server runs is not defined; the lifecycle stops first.
2. **The lifecycle gets a `stop` step, and `serve` stops first.** Same behaviour for every build.
3. **A spec release is its own folder with one `dag.md`.** In the reference folder the spec's lifecycle is `spec/dag.md`, beside the folder's own bashy-run `dag.md`; `spec/README.md` lists the files of a spec release. The drill fixture copies them byte for byte. Nothing about the spec lives only in a benchmark any more.
4. The drills are rerun on v2.2: build with `codex-gpt6.1-terra` (the lifecycle check now requires serve, a page that answers, stop, and a page that no longer answers), then operate with `codex-gpt6-luna` (order: build, test, install, serve, run, fetch, stop; the grader also checks that the page no longer answers).

## Acceptance
- bashy: spec v2.2 lints clean; the reference certifies 3 of 3 with no noisy assertion and every mutant is killed; form's own tests and acceptance checks unchanged.
- agent-bench fixtures and private grader updated, with controls (empty workspace fails; the reference passes, including serve and stop).
- Build 3 runs and operate 3 runs reported, every non-pass classified.
- The report and the standard updated; the bashy `exec` finding filed if it is a product defect.
