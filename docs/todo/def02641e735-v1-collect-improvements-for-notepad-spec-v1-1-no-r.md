---
id: def02641e735
kind: enhancement
title: V1 collect improvements for notepad spec v1.1 (no run until the operator says the list is enough)
seq: 810
status: todo
priority: p1
labels:
    - conform
created: 2026-11-26T20:58:54.899933Z
sprint: 734
sprint_id: c0fe136f-1cdc-5b2b-bc4f-cec6d3f9680d
sprint_title: 'Notepad spec v1.1: collect improvements from the builds, then one more round'
---

Operator ruling 2026-11-26, during Sprint 726: record spec improvements as a follow-up, and collect more for v1.1 before running another round. This story is the collection. Add an item whenever a build, a judge or a user finds a spec weakness; give the evidence (run, assertion, digest). No spec change, no hidden-case change and no build round starts from this story.

## Collected so far

1. **API JSON is judged byte for byte, and the spec never states the format.** Evidence: Sprint 726, `opencode-glm-5.3-flash` run 1 (snapshot `ab00b0ce25910b24`): 17 of 177 assertions failed (visible N-23, N-24, N-25 and 14 hidden steps), all secret-field checks made with `curl`. The refuse and accept decisions were right; the build printed the API's JSON with spaces and another key order. The contract's output rules cover CLI `--json` output only. Preferred fix: make those checks structural (pipe the `curl` output through `jq -cS .` in the visible assertions and the hidden cases that copy them). Alternative: state "API responses are compact JSON with sorted keys" as a rule, which turns an accident of the reference into a requirement.
2. **The reference differs from its own spec in four places** (found by the judge in R2; no visible or hidden case asserts them): `--format` is ignored and content sniffing always decides; content sniffing is broader than the contract (content holding certain html tags is html where the contract says txt); the first body write after an empty `add` is `r2` where the contract says `r1`; one `features.yaml` acceptance line fails on the reference (`add ... --fields id,title` exits 2 and the note is stored anyway). For each, decide whether the contract or the app is right, then assert it.
3. **The spec author's open questions** (R1): should the binary get its own `stop`, and should `add` start the server; which page buttons are required of every implementation; should pdf and png export be checked beyond the reported `format`.
4. **The spec author's known issues** (R1): KI-1 exit 255 and a long dial error when the server is down; KI-2 html and pdf import depend on `bashy lens`; KI-3 page field texts are not programmatically associated with their controls.
5. **Task statement, not spec:** add "deliver only when `conform run` shows every assertion PASS" (the failed build delivered with three visible assertions failing).
6. **Lifecycle test defect (agent-bench `venue/lifecycle-notepad.sh`):** its `installed` check looks for `"body":"hello"` as compact text, so it fails a build whose CLI prints valid JSON with spaces. Parse the JSON instead. It changed no verdict in Sprint 726.
7. **Structure, for discussion:** all 37 visible assertions run in order against one server on one fixed port and one data folder, where form's each run in a fresh HOME; `stop` is defined per folder (a pid file) where form's is per user.
8. **Time:** `opencode-glm-5.3-flash` used 21 and 25 minutes of the 30-minute cap; `codex-gpt6.1-terra` about 6. Note the cap when comparing rounds.

## When the list is enough (later stories, not filed yet)
Spec v1.1 by an author session; gate (lint, certification, mutation); hidden cases updated by a judge of another vendor, new digests; one build round under `docs/sprint-726-protocol.md`. For a changed assertion that fixes a reference defect, the rule is the reverse of today's: it fails on the old reference and passes on the fixed one (operator, 2026-11-26; also on Sprint 730's thread).
