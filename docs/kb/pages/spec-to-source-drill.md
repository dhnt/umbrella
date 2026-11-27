---
id: 01a21794-377c-7f36-bca3-5bddae1380af
seq: 24
form: page
type: runbook
title: Set up and evaluate an agent tool or model for spec to source (the shapeware drill)
description: 'WHEN you set up or run an evaluation of an agentic tool or model binding for building an app from its shapeware spec (qualify a new tool/model, find a vendor''s lowest adequate tier, check a new spec; spec2src, conform, agent-bench): one-time setup per app (sound spec, independent hidden cases, isolated grader, controls, fixture, private drill directory, protocol, smoke), then per binding (quota check, probe, three runs, batch gate with failure classification, k of 3), with the traps: agent shell, loop host vs venue, runner cutoff, quota refusals, keychain logins'
tags:
    - shapeware
    - conform
    - spec2src
    - drill
    - benchmark
status: validated
evidence: Sprint 723 drill on form (28 scored runs, six amendments) and the Sprint 726 drill on notepad, a service app, with hidden cases written from part A by an agent (umbrella docs/sprint-726-report.md); venue scripts in agent-bench packs/spec2src/venue
source:
    tool: claude
created: "2026-11-26T11:18:39Z"
updated: "2026-11-26T21:32:52Z"
---

Goal: decide, with evidence, whether an agent binding (tool:model) can build an app from its shapeware spec alone. Use it to qualify a new tool or model, to find the lowest adequate tier of a vendor, or to check a new spec. Reference run: Sprint 723 on bashy's `form` (`docs/spec2src-protocol-v2.md`). Retro with the reasons behind each rule: [[shapeware-drill-retro-sprints-722-725]].

## A. One-time setup (per app and spec version)
1. **Sound spec.** `conform spec check DIR` reports nothing. On a gate lane: `conform cert` passes the reference 3 times with no noisy assertion; `conform mutate` kills every mutant. Authoring guide: [[shapeware-lift-app]].
2. **Hidden cases** (private store, never in a public repo or a subject's reach): the documented behaviours with other ids and values. One small contract file per case; each creates its own state and runs alone in a fresh HOME. One case per input format, so one gap costs one case.
3. **Grader on the test host.** Grade the snapshot, never the live workspace. Each phase (visible contract, each hidden case, page interaction) gets its own network and process namespace and a fresh HOME. Remove native executables from the snapshot first. Put the digests of the hidden set, contract, judge binary and snapshot in every grade.
4. **Controls.** Reference through the full grader 3 times, all pass; an empty workspace fails every layer. Pin control shims to absolute tool paths.
5. **Fixture** in agent-bench `packs/spec2src/<task>/fixture`: the spec files byte for byte plus `TASK.md` (deliverable, venue with versions, the judge command). Update the digests in `task.yaml`; run `python3 packs/spec2src/selfcheck.py`.
6. **Private drill directory** (`S2S_HOME`, outside any source tree): `tools/conform` (the standalone judge built for the session host, digest recorded), `adapters/` (a frozen copy of the bashy adapter cache, digest list kept), `guard.sb` (from `packs/spec2src/venue/guard.sb.template`). Check the guard: the judge runs under it; the hidden cases and the evidence are unreadable.
7. **Protocol** committed before any scored run: question, bindings, pass rule, conditions, controls, digests, seeds, rerun rules, disclosures. Later changes are numbered amendments with a reason.
8. **Smoke** with a binding that is not a subject: `packs/spec2src/venue/run.sh AGENT smoke 1`. The chain must run end to end (session, snapshot, grade). Then freeze the harness.

## A, when the app is a service (second drill: a notes server, hidden cases written by an agent)
- **Per-case state is whatever the app keeps:** HOME, a data folder, a port, a pid file. Each hidden case gets its own of each, on a port the visible contract does not use. Never begin a case with `stop`: a pid file left by another phase can name a process of another namespace.
- **Each detection route is its own case.** "One case per input format" means one per route by which a format is recognised (extension, content, standard input, a flag).
- **Text and JSON are judged differently.** Only a command that carries `--json` is compared structurally; a `curl` check needs the exact text. Write hidden steps the same way the visible contract does.
- **A case that fails the reference.** If the case is wrong, fix it. If the reference contradicts its own contract, drop the case, report the defect to the spec owner and disclose it in the protocol. It blocks the builds only when a visible assertion depends on it.
- **Hidden binary inputs:** make them with the reference's own exporter or a standard tool, and record how.
- **Build before grading.** If the launcher does not build on demand, the grader runs the spec's `build` step on the snapshot before the behaviour phases, offline, in its own namespace. The task says what the venue's module cache holds (standard library or vendored only, unless stated).
- **Lifecycle phase.** After the behaviour phases, run every step of the spec's `dag.md` (never the candidate's copy) on a fresh copy of the snapshot, then check the service: it answers after `serve`, the installed command works, nothing answers after `stop`. Report this verdict apart from the behaviour verdict. Pattern: agent-bench `packs/spec2src/venue/lifecycle-notepad.sh`; a harness check that reads JSON parses it, never matches it as text.
- **Also fix before the runs:** the page interaction, the method of the hidden-set digest, and controls for the lifecycle phase (the reference passes, an empty folder fails, one broken step fails alone).

## B. Evaluate a binding (repeat per tool or model)
1. Confirm it is registered: `bashy agent list`. Check its plan quota before you start; three runs plus a probe must fit one window.
2. **Probe:** `S2S_HOME=... packs/spec2src/venue/probe.sh AGENT` must print `PROBE AGENT ok` (signed in, has quota, the judge resolves on its PATH). Tools that cannot answer a one-shot probe are checked by their first batch.
3. **Three runs,** one per batch, bindings of different vendors in parallel: `S2S_HOME=... S2S_GRADE_CMD=... packs/spec2src/venue/run.sh AGENT b1 1 SEED`, then `b2 2`, `b3 3`. Rows land in `$S2S_HOME/runs/<batch>/results.jsonl`, raw grades in `$S2S_HOME/grades`.
4. **Gate each batch.** For every non-pass read the per-assertion grade and the screen log, and classify: spec gap, agent defect, judge defect or venue fault.
   - Venue fault (provider refusal, launch failure, harness break): rerun that cell, keep both attempts.
   - Anything the agent did or failed to do: a fail, never a rerun.
   - Render a failing page before trusting a UI failure. A judge defect pauses the drill until the judge is fixed and the reference re-certifies.
5. **Result:** k of 3 per binding. Qualified at 2 of 3 or better. For a ladder: start at the vendor's middle tier, step down at 2 of 3 or better, up otherwise; one step gives a bound, not a minimum.
6. **Report** exact binding names, k of 3, session times, classified failures, digests, amendments and limitations. Record the measured minimum band in the app's `SKILL.md`.

## Traps (each one cost a rerun or a wrong verdict)
- **Agent shell.** `bashy chat` routes agent commands through bashy and operator tool settings may pin the same. `venue/env.sh` sets a plain system shell for every arm so a tool named in the task resolves to the binary on PATH. The installed bashy on the session host can also be older than source.
- **Loop host differs from venue.** The subject's judge runs on the session host; the grader runs on the stated venue. A cached build or a host-only interpreter feature passes in the loop and fails at the venue. The grader drops native binaries; the task must state the venue's versions.
- **Quiet-workspace cutoff.** The runner ends a session after a period with no file written. `venue/run.sh` sets it to the wall-time cap; a shorter one cuts long first planning turns.
- **Quota.** Probes, worker sessions and scored runs share one plan quota per binding. A refusal is a venue fault. The runner recognises some refusal wordings only; "Individual quota reached" is logged as a candidate fail with a missing launcher after about 200 seconds, so read the screen log before counting a short empty run as a fail.
- **Nothing delivered after a long first turn.** A session that reads the spec, thinks for minutes and ends without writing a file is an agent fail when the screen log shows no refusal by the provider; a refusal makes it a venue fault. Read the log before counting.
- **Subject hygiene.** Give no drill-related worker story to a subject binding, and disclose any exposure in the protocol.
- **Logins in the OS keychain** need the runner's recorded opt-ins, or the isolated arm is signed out.
- **Auto-update** off for every tool during the run.
- **Test host.** A system copy of a tool on the host's base PATH can shadow the lane-built one. Tools that build on demand need a prewarmed cache to run offline in a fresh HOME. Move binaries off the host as base64 and compare digests.
- **Shell utilities.** In a bashy shell some GNU flags are missing (`grep -a`); use the system binary by absolute path in venue scripts.
- **Leaked servers on the session host.** Subjects start their app's server while checking their work, and nothing stops it when the session ends: after 28 runs, 63 candidate server processes were still running on the session host. After every batch, stop the processes whose path is under the run workspaces and remove the workspaces and arm directories; never by a broad name match.
- **Changing conditions mid-drill.** A script edited while batches are running splits them across two conditions. Change between batches, and write the amendment first.
