---
id: def02641e735
kind: enhancement
title: 'V1 collect improvements to the shapeware spec method from the builds (generic fixes; notepad is the test case; no run until the operator says the list is enough)'
seq: 810
status: todo
priority: p1
labels:
    - conform
created: 2026-11-26T20:58:54.899933Z
sprint: 734
sprint_id: c0fe136f-1cdc-5b2b-bc4f-cec6d3f9680d
sprint_title: 'Shapeware spec method: collect improvements from the builds (notepad is the test case), then one more round'
---

Operator rulings 2026-11-26, during Sprint 726:
1. Record improvements as a follow-up and **collect more before running another round**. This story is the collection. No spec change, no hidden-case change and no build round starts from it.
2. **The solution is generic, not just for notepad.** Each weakness is fixed where every shapeware app benefits: the spec format, the judge (`conform`), the lint (`conform spec check`), the kb runbooks, the drill harness. A change in notepad's own files is only the instance that proves the generic fix.
3. **What applies only to notepad is added only for notepad.** An item goes in the generic table when another app could meet the same weakness; otherwise it goes in the notepad-only list below and changes nothing outside notepad's folder.

Add an item whenever a build, a judge or a user finds a weakness. Give the evidence (run, assertion, digest), the generic fix, and the notepad instance if there is one.

## Collected so far

| # | Weakness (generic) | Evidence in Sprint 726 | Generic fix, and where | Notepad instance |
|---|---|---|---|---|
| 1 | **Output that is JSON is judged byte for byte unless the command carries `--json`.** A spec then demands a byte format it never states. | `opencode-glm-5.3-flash` run 1 (snapshot `ab00b0ce25910b24`): 17 of 177 assertions failed, all `curl` checks of the HTTP API; the decisions were right, the JSON had spaces and another key order. The author and the judge both listed this split as a runbook guess. | **Judge:** a way to mark any console block as JSON so it is compared structurally (or the judge does so whenever the expected text parses as JSON). **Lint:** flag a JSON-looking expectation that will be compared as text. **Runbook** `shapeware-spec-from-app`: state the judging split until the judge changes. | N-23, N-24, N-25 and the hidden steps that copy them. |
| 2 | **A spec can state rules its reference does not follow, and nothing detects it.** The lint is static; certification only runs the assertions that exist. | The judge found four: `--format` ignored; content sniffing broader than the contract; `r2` after an empty `add` where the contract says `r1`; one `features.yaml` acceptance line fails on the reference. | **Judge or lint, dynamic:** run every `features.yaml` acceptance line on the reference at certification. **Lint:** every rule in the contract cites at least one assertion that exercises it (a rule with no assertion is an open question). **Format:** say who wins when contract and reference disagree, and how the difference is recorded (known issue). | The four points; decide each, then assert it. |
| 3 | **A service with no stop verb and no auto-start has no model in the format.** Where `stop` may live, how a contract starts its server, what `stop` is scoped to (folder, user). | The author put `stop` in a launcher with a pid file per folder; form's is per user. Author's open question 1; runbook guesses of the author (2, 3) and the judge (2). | **Format + runbooks:** a "service rules" pattern: start, readiness check, stop and its scope, state kept across a stop; what the reference command is for a wrapped app. | Open question 1. |
| 4 | **Page rules assume labelled controls; no fallback when the reference's page fails them.** | Author's runbook guess 1, KI-3, open question 2. | **Runbook + format:** what to assert when the reference page has no programmatic labels (text inventory), and how to record the gap as a known issue an implementation may improve on. | KI-3; which buttons are required. |
| 5 | **Binary and converted formats: fixture provenance and extractor-specific output.** | The only PDF example is one the reference exported itself; the expected text is specific to one extractor (`## Page 1`); pdf and png export are asserted only by the reported `format`. KI-2: conversion depends on a tool at the venue. | **Runbook:** how to make and record binary fixtures; assert properties, not an extractor's exact text; a tool the app shells out to is a venue line, stated in the task. | KI-2; author's open question 3. |
| 6 | **State model of a contract: ordered assertions against one server versus a fresh state per assertion.** The drill runbook assumes state lives in HOME. | All 37 visible assertions run in order on one fixed port and data folder; the judge had to invent per-case servers, ports and data folders (judge's guesses 1, 2, 10). | **Runbooks:** both models, when each fits, and what a hidden case must isolate (HOME, data folder, port, pid file). | none needed if the generic rule allows it. |
| 7 | **Grader assumes a launcher that builds on demand and no module dependencies.** | The judge added a build step and an offline module source (guesses 3, 4). | **Harness + drill runbook:** the spec's `build` step runs before grading; the task states what the venue's module cache holds. | none. |
| 8 | **No idiom for "any non-zero exit".** | KI-1 leaves the exit code open; the judge used shell wrappers (guess 9). | **Judge/format:** an exit expectation "non-zero". | KI-1. |
| 9 | **"A surviving mutant is a missing assertion" is not always true.** | Two survivors were artefacts of the command's shape (redirections and pipes absorbed by the mutant shim; mutations hidden inside compound commands). | **Judge** (the mutant shim) and **runbook** (restructure the command). | none. |
| 10 | **Task statement.** A builder delivered with visible assertions failing. | `opencode-glm-5.3-flash` run 1: 3 visible FAIL at delivery. | **Runbook** `shapeware-source-from-spec` and the task template: deliver only when the judge shows every visible assertion PASS. | `TASK.md` of `t3-notepad`. |
| 11 | **Lifecycle test compares JSON as text.** | `venue/lifecycle-notepad.sh`, check `installed`: looks for `"body":"hello"` compact. It changed no verdict. | **Harness:** parse the JSON; make the script generic (app name, create command, page check as parameters) instead of one per app. | the script itself. |
| 12 | **Session time is not part of the result.** | `opencode-glm-5.3-flash` used 21 and 25 of 30 minutes; `codex-gpt6.1-terra` about 6. | **Protocol/report:** report time next to the verdict; state the cap when rounds are compared. | none. |

## Notepad only (no generic change)

These are facts and decisions about this one app. They become notepad spec v1.1 and nothing else.

| # | Item | Evidence | Change, in notepad's folder only |
|---|---|---|---|
| N1 | `--format` is ignored; content sniffing always decides. | Judge, R2. | Decide: fix the app, or drop `--format` from the contract. Then assert it. |
| N2 | Content sniffing is broader than the contract: content holding certain html tags is html where the contract says txt. | Judge, R2. | Decide which is right; write the rule as a defined set with a boundary pair. |
| N3 | The first body write after an empty `add` is `r2`; the contract says `r1`. | Judge, R2. | Decide; assert the revision after an empty `add`. |
| N4 | The acceptance line `add ... --fields id,title` fails on the reference (exit 2, and the note is stored anyway). | Judge, R2. | Correct the line or the app; a refused command must not store. |
| N5 | Which page buttons every implementation must have (layout and copy buttons, or only Save Note and New Note). | Author's open question 2. | Owner decision, then the UI rule. |
| N6 | Should `add` start the server, and should the binary have its own `stop`. | Author's open question 1. | Owner decision (the generic service pattern is item 3 above; this is notepad's choice within it). |
| N7 | pdf and png export are asserted only by the reported `format`. | Author's open question 3. | Owner decision: pin a property of the written file or leave it open. |
| N8 | KI-1: a verb against an unreachable server prints a long dial error and exits 255. | Author, R1. | Fix the app's error and exit code, then assert them. |
| N9 | KI-2: html and pdf import call `bashy lens`, against the README's pure-Go claim. | Author, R1. | Correct the README, or make the import self-contained. |

Sprint 726's R4 applies the runbook wording that is already certain (the guesses listed on stories `7512c17bc9d5` and `f232758ae073`); what needs a decision, a judge change or a lint rule stays here.

## When the list is enough (later stories, not filed yet)
The generic fixes first (judge, lint, format, runbooks, harness), each with its own test; then notepad spec v1.1 as the instance, by an author session; gate (lint, certification, mutation); hidden cases updated by a judge of another vendor, new digests; one build round under `docs/sprint-726-protocol.md`. For an assertion that fixes a reference defect the rule is the reverse of today's: it fails on the old reference and passes on the fixed one (operator, 2026-11-26; also on Sprint 730's thread).
