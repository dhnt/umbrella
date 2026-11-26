---
id: 01a21794-377c-7f36-bca3-5bddae1380af
seq: 24
form: page
type: runbook
title: 'Run a spec-to-source drill: protocol, harness, batches, gates and the traps'
description: 'WHEN you measure whether an agent binding can rebuild an app from its shapeware spec (a qualification drill, a model ladder, a spec2src benchmark): protocol before runs, independent hidden cases, isolated grading on the test host, controls, smoke, arm probes, batch gates with failure classification, the ladder rule; traps: agent shell shadowing the judge, loop host differing from the venue, quiet-workspace cutoff, quota, keychain logins, auto-update'
tags:
    - shapeware
    - conform
    - spec2src
    - drill
    - benchmark
status: candidate
evidence: Sprint 723 (umbrella docs/spec2src-protocol-v2.md, amendments 1-4); Sprint 722 protocol
source:
    tool: claude
created: "2026-11-26T11:18:39Z"
---

Goal: measure whether a named agent binding can rebuild an app from its shapeware spec alone, judged by behaviour. Reference run: Sprint 723 (form app, spec v2); protocol in `docs/spec2src-protocol-v2.md`.

## Order of work
1. **Protocol first.** Write the question, subjects, outcome, conditions, controls and rerun rules before any run. Later changes are numbered amendments with a reason and apply to later batches only.
2. **Spec.** Check the spec folder with `conform spec check DIR`; fix every finding. Certify the reference (`conform cert`, 3 runs, no noisy assertion) and measure suite strength (`conform mutate`, every mutant killed).
3. **Hidden cases.** Same documented behaviours with other ids and values. Each case is its own small contract, creates its own state and runs alone in a fresh HOME. Keep them in a private store; publish only digests.
4. **Grader.** Grade a snapshot, never the live workspace, on the test host. Give every phase (visible contract, each hidden case, page interaction) its own network and process namespace and a fresh HOME. Remove native executables from the snapshot first. Record digests of the hidden set, contract, judge binary and snapshot in every grade.
5. **Controls.** Reference through the full grader 3 times (all pass), an empty workspace (fails every layer).
6. **Harness.** Fixture = the spec files plus a task file that states the venue and names the judge command. Put a standalone `conform` on the subject's PATH. Freeze the adapter cache. Guard: deny reads of source trees and evidence, deny writes outside the run area.
7. **Smoke** with a binding that is not a subject, through the whole chain. Freeze the harness.
8. **Probe every subject binding in a real isolated arm** without the task: ask it to run `conform version`. This catches sign-in, quota and tool-reachability faults for free.
9. **Batches.** One run per binding per batch, seeded order, bindings in parallel. Gate after each batch.
10. **Gate.** Classify every non-pass as spec gap, agent defect, judge defect or venue fault, from the evidence. Render a failing page before trusting a UI failure. A venue fault reruns the cell and keeps both attempts; anything the agent did is a fail.
11. **Ladder.** Start tier 3 times; step down at 2 of 3 or better, up at 1 of 3 or worse. One step gives a bound, not a minimum.
12. **Report** per binding with exact names, k of 3, the classified failures, digests and limitations.

## Traps (each cost a rerun or a wrong verdict)
- **Agent shell.** `bashy chat` routes agent commands through bashy, and operator tool settings may pin the same. Use a plain system shell in every arm (`BASHY_FORCE_AGENT_SHELL=0`, `BENCH_PLAIN_SHELL=1`) so a tool named in the task resolves to the binary on PATH.
- **Loop host differs from venue.** The subject's judge runs on the session host; the grader runs on the stated venue. A cached build or a host-only interpreter feature passes in the loop and fails at the venue. Strip native binaries at grading and state the venue's versions in the task.
- **Quiet-workspace cutoff.** A runner that ends a session after N seconds without a file write cuts long first planning turns. State the rule in the protocol or set it to the wall-time cap.
- **Quota.** Probes, worker sessions and scored runs share one plan quota per binding. Budget it; a refusal is a venue fault, and the runner's refusal pattern must match each vendor's wording ("Usage limit reached", "Individual quota reached").
- **Subject hygiene.** Do not give drill-related worker stories to a subject binding.
- **Login storage.** Tools that keep their login in the OS keychain need the runner's recorded opt-in, or the isolated arm is signed out.
- **Auto-update.** Turn every tool's self-update off for the run.
- **Test host PATH.** A system copy of a tool on the host's base PATH can shadow the lane-built one; pin by absolute path in control shims. Tools that build on demand need a prewarmed cache to run offline in a fresh HOME.
- **Binary transfer.** Move binaries from the test host as base64 and compare digests; a raw pipe through a shell bridge can corrupt them.
