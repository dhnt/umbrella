---
id: 7512c17bc9d5
kind: feature
title: 'R1 reverse: an agent writes the shapeware spec for the second app'
seq: 782
status: assigned
priority: p0
labels:
    - conform
created: 2026-11-26T11:23:43.465764Z
weave: 281
assignee: muse-wonder
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
---

One binding (spec author) writes CONTRACT.md, features.yaml, examples and the behaviour section of SKILL.md for the second app, following kb runbook shapeware-spec-from-app. Done when conform spec check is clean, the reference certifies (3 runs, no noisy assertion) and every mutant is killed, all on a gate lane. No change to the app's behaviour. The conductor gates; it does not write the spec. Plan: umbrella docs/plan-reverse-sdlc-workflow.md (iteration 2). Operator review and decisions 1-3 before start. Reuse the Sprint 723 harness as it is; build and test only on a claimed gate lane.

## Triage for the start (operator rulings 2026-11-26, after Sprint 731)

Code inspected (bashy main `3d708c4f`): `examples/desk/notepad` is a Go app of about 3,600 lines (`main.go`, `cli.go`, `convert.go`, `export.go`, tests, `notepad.bsh`, `register.sh`, `shaped.json`, `contract.bsh`). Its `dag.md` has `serve`, `test`, `register` and `show`, with no `Band:` lines and without `source`, `build`, `install`, `run` or `stop`. It has no `SKILL.md`, `CONTRACT.md` or `features.yaml`. `form` (same folder level, spec v2.2) is the worked example of everything asked here.

Added to this story:
1. **The spec author also writes the lifecycle.** Besides `CONTRACT.md`, `features.yaml`, `examples/` and `SKILL.md`: `spec/dag.md`, the lifecycle of the app as a spec, and `spec/README.md`, the file list of a spec release, in the layout of `examples/desk/form/spec/`. Steps run with `sh` and need no bashy: `source`, `build`, `test`, `install`, `run`, and for this service `serve` and `stop`, each with `Effects:` and `Band:` (`none` or `unmeasured`). The contract defines how the service is stopped, with at least one assertion (form's "Service rules", F-17 to F-20, are the model). The folder's own `dag.md` gains the missing steps and band lines so the lint passes on the reference folder too.
2. **The author works from the kb runbook** `shapeware-spec-from-app` (`bashy kb show shapeware-spec-from-app`; shipped in bashy `kb/defaults`), not from the conductor's coaching. The conductor notes every point where the author had to guess or the runbook was wrong, and those become runbook fixes in R4.
3. **Done** is unchanged and adds: `conform spec check` reports nothing on the reference folder and on the assembled spec release; the reference passes the lifecycle end-to-end test of story E1.
4. No owner review step is required (operator: not needed for this sprint). The author still lists open questions in the spec; the conductor records them for the report.

Lessons from form that the brief to the author must carry: a rule given by example is a lint error, define the set; a service needs a stop that the contract can check (a signal is not one: bashy todo `941f35b6`); state the venue; the reference decides what the lifecycle may demand, so run every step on the reference before claiming it.

## Conductor note for the author's session (2026-11-26; mechanics only, no spec advice)

Operator go 2026-11-26. Spec author: `muse-wonder`. The conductor gates and records; it answers questions about the venue, not about the spec.

- **Where you work.** The `bashy/` submodule of your workspace, folder `examples/desk/notepad` (if `bashy/` is empty: `git submodule update --init bashy`). Create branch `s726-r1-notepad-spec` from bashy `origin/main` (`3d708c4f`). Commit on that branch only. Do not push, do not merge, do not change the umbrella pin: the conductor fetches the branch from your workspace.
- **Commit trailers** (the hook refuses a commit without them): `Sprint: #726`, `Story: #782`, `Story-ID: 7512c17bc9d5`, `Agent: muse-wonder`.
- **Read first:** `bashy kb show shapeware-spec-from-app` (your procedure) and the worked example `examples/desk/form` (`CONTRACT.md` v2.2, `features.yaml`, `SKILL.md`, `dag.md`, `spec/dag.md`, `spec/README.md`).
- **Never build, test or run notepad on the session host** (no `go build`, no `go test`, no server, nothing that opens a page). Use the test host through the conductor's helper, a plain script outside the repository:
  - `/bin/bash ~/.bashy/evidence/s726/tools/lane sync bashy/examples/desk/notepad` copies your folder to the lane (it replaces the lane copy);
  - `/bin/bash ~/.bashy/evidence/s726/tools/lane run 'CMD'` runs `sh -c CMD` in that folder on the lane;
  - `/bin/bash ~/.bashy/evidence/s726/tools/lane reap` stops processes left on the lane.
  The lane is Linux x86-64, headless (no display), with Go 1.27.4, Node, Python 3 and Chrome; `HOME` and `TMPDIR` are lane-local folders; `open` and `xdg-open` do nothing. Build with `GOWORK=off go build -o "$TMPDIR/notepad" .`. Judges on the lane PATH: `conform-main spec check DIR` (the lint) and `conform` v0.1.1 (`run`, `cert`, `mutate`). `conform cert` needs `--dir` set to the folder that holds the examples, or file-reading assertions are reported as noisy. Stop every server you start (`lane reap` when in doubt). A mutation pass is slow (17 minutes on form's 21 assertions): run it when the certification is clean, not on every edit.
- **Do not change notepad's behaviour.** A defect you find in the app becomes a known-issue entry in the spec and a line in your report, not a source change. The only non-spec files you may edit are `dag.md` (missing steps and band lines) and what the lifecycle steps need to run with `sh` and no bashy; say so in the report if you add any.
- **When you stop,** end with a report in your final message: the branch and commit; what passed on the lane (lint on the folder, certification runs, mutants killed of total) with the commands you ran; your open questions for the owner; and **every point where the runbook left you guessing or was wrong**. That list is a deliverable of this sprint: do not smooth it over.
- If a session ends before the work is done, commit what you have on the branch and say where you stopped; the conductor resumes the same run.

## Result (2026-11-26)

Author `muse-wonder`, one session of 40 minutes (weave run 281), no conductor coaching beyond the mechanics note above. Landed on bashy main as `eb41d87b` (spec v1.0): `CONTRACT.md` (37 assertions), `features.yaml`, `SKILL.md`, `examples/` (txt, md, json, html, pdf), `spec/dag.md`, `spec/README.md`, the folder's `dag.md` with the missing steps and band lines. No Go source changed. Added for the lifecycle: `build.sh` and an sh launcher `notepad`, which carries the `stop` verb (the Go binary has none).

Gate, run by the conductor on gate lane 2 from the committed branch: `conform spec check` (conform main) reports nothing on the reference folder and on the assembled spec release; `conform cert` v0.1.1, 3 runs, verdict PASS, 37 results, none noisy (contract sha256 `1624be7b...`); `conform mutate` 124 of 124 killed (8 minutes); notepad's own unit tests pass; the lifecycle end-to-end test of E1 passes 3 of 3.

Open questions the author left for the owner (recorded for the report, not blocking):
1. The Go binary has no `stop` verb and no verb starts the server, so `stop` lives in the launcher. Should the binary get `stop`, and should `add` start the server as `form add` does?
2. Are the page's layout and copy buttons required of every implementation, or only the title, the body, Save Note and New Note?
3. pdf and png export are asserted only by the reported `format`, never by the written bytes. Should a later spec pin a property of those files?

Known issues the author recorded in the spec: KI-1 a verb against an unreachable server prints a long dial error and exits 255; KI-2 html and pdf import call `bashy lens`, which contradicts the README's pure-Go claim; KI-3 the page's field texts are not programmatically associated with their controls.

Runbook guesses (`shapeware-spec-from-app`), for R4:
1. Step 6 assumes labelled page controls and a `ui` inventory assertion; there is no fallback when the reference's page fails those rules (the author used a console page check and KI-3).
2. Nothing covers a service that has no stop verb and no auto-start: where `stop` may live, how a contract starts its server.
3. The runbook never says what the reference command is for a wrapped app (the conductor's note said to build the Go binary; certification only works against the launcher).
4. Assertions whose last command has no `--json` are judged as plain text, so the open-object form does not apply; the runbook does not mention this split.
5. "A surviving mutant is a missing assertion" was wrong twice: two survivors were artefacts of the command's shape (redirections and pipes absorbed by the mutant shim, mutations hidden inside compound commands); the fix was restructuring the commands.
6. One example per input format: no PDF fixture existed, so the example is one the reference exported itself, and its extracted text is extractor-specific. Nothing on fixture provenance.
7. Which `dag.md` the lint reads in the reference folder is not stated: it reads the folder's root file, not `spec/dag.md`, so both had to be clean.

Conductor's observations for the report: all 37 assertions run in order against one server on one fixed port and one data folder (form's run each in a fresh HOME); `stop` is defined per folder (a pid file), where form's is per user; KI-2 means an implementation that follows the reference needs an extractor on the venue for html and pdf, which the R3 venue must state.
