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

## Progress (2026-11-26)

- **Spec v2.2 merged** (bashy `9ee40025`): service rules and assertions F-17 to F-20 in `CONTRACT.md`; a `stop` step in the folder's `dag.md`; the spec's own lifecycle in `spec/dag.md` with `spec/README.md` listing the files of a spec release. `conform spec check` reports nothing on the reference folder and on the assembled spec release. Mutation: 127 of 127 killed.
- **A defect in the reference, found by the new assertions and fixed** (bashy `d486a5d0`). Root cause: `stop` signals the server and then removes the server's state file, which the stopping server removes too; when the server wins, `rm -f` reports the missing file and the script exits 1 (about 2 of 8 stops, and one failure of F-17 in a control). Two causes recorded: the script must not depend on that removal (fixed), and the pure-Go `rm -f` does not ignore a file that vanishes just before the unlink (coreutils todo `8302f07a`, not fixed: frozen baseline). After the fix: 0 failures in 30 add-then-stop cycles; the reference certifies over 10 runs, 21 of 21, none noisy. Form's server tests and acceptance checks are unchanged (11 PASS, 4 TBD).
- **Fixture** (agent-bench `8dcad00`): a spec release of `form` at v2.2, six files byte for byte from bashy, `dag.md` from `spec/dag.md`.
- **Private grader v2.4**: the lifecycle check now requires the service to work: `serve` alive, a new form's page answers, `stop` exits 0, the page no longer answers. Controls pass (empty workspace fails; the reference fails only on a missing `build.sh`; the reference with `build.sh` passes 3 of 3).

## Run conditions for the reruns, fixed before they start

As for story T1, with these changes: fixture and grader as above (contract digest `737e7c4658bce7e4`, lifecycle `9ad2c66b609650ab`); lanes are headless. Build: `codex-gpt6.1-terra`, 3 runs; pass = behaviour PASS on every layer and lifecycle PASS including the service. Operate: after the build runs, with the task reordered (build, test, install, serve, run, fetch, stop) and one more check (the page no longer answers after the stop); the no-model control first, then `codex-gpt6-luna`, 3 runs. A provider refusal is a venue fault. Every non-pass is classified from the logs before it is counted.
