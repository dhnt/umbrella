---
id: 64294d3d0304
kind: bug
title: S14 Recover Bash compatibility with the dialect on
seq: 93
status: todo
priority: p1
labels:
    - bashsharp-review
created: 2026-11-10T17:39:59.705708Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

## Re-baseline (manager, 2026-11-10) — read first
The "79 + 7 dialect-on" premise below is STALE. On bashy a9958c91 the sealed gate gives `make test-bash-container` (dialect off) 86/86 AND `make test-bash-container-bashpp` (dialect on) 86/86 on the Linux test host (non-root testee). bashsharp claims.md was refreshed (bashsharp cd8b8c9). The historical dialect-on seven were comsub, comsub2, errors, func, trap, type, varenv; they no longer fail. Do not confuse them with the environmental 79/86 from running `make test-bash` as root (execscript, glob-test, intl, new-exp, printf, redir, test), which bashy now refuses (bashy 550fc0ac).

Re-scoped work (replaces the parser plan until a probe proves it is needed):
1. Keep dialect-on in the release gate as the regression guard: the gate runs both modes (`make test-bash-gate`, bashy follow-up from todo 1b05b83d9c33) and compares failing fixtures BY NAME to the previous evidence; a new name blocks.
2. Add a few targeted probe scripts for the review's E-live forms that the 86-fixture corpus may not exercise: `func() {…}` and `func () {…}` define a Bash function `func`; `ls //tmp` and other argument uses of `//` stay Bash; `func NAME(...)`, methods and leading-`//` comments keep their Bash# meaning in .bsh. Run each dialect on and off; the dialect must not change ordinary Bash meaning.
3. Only if a probe fails: the original lookahead change below (sh/syntax start-site recognizer, no maxLookahead increase), red/green on that probe.

Acceptance (re-scoped): both gate modes 86/86 with named-fixture evidence; the probes pass dialect on and off, or each failing probe has a recorded fix; no change to dialect activation, aliases or failure defaults.

## Outcome (original, pre-2026-11-10)
Recover Bash compatibility with the Bash# dialect on, without changing when the dialect is active (claude review G3). bashy runs .sh with the dialect on (AgentOSBashPPDefault); the recorded result is 86/86 dialect-off versus 79 + 7 dialect-on (bashsharp/docs/claims.md), so ordinary Bash can silently change meaning.

Dependencies: S3/S5 (diagnostic identities). S11 documents the result.

## Scope
- `func` is a keyword only before `NAME(` or a non-empty receiver; `func() {…}` and `func () {…}` remain Bash function definitions.
- A leading `//` is a comment only at command position; `ls //tmp` and other argument uses stay Bash.
- Work in the sh/syntax start-site recognizer (sh/syntax/bashpp_startsites.go area); do not raise maxLookahead.
- Preserve existing import/type parsing. For `func() {…}` and `func () {…}`, the Bash function interpretation stated above is authoritative; do not also preserve a conflicting typed interpretation. S4 warnings apply only to forms actually recognized as Bash# after this correction. Record exact expected parses before implementation.

## Acceptance
- Named dialect-on failing fixtures recovered by the lookahead change are listed by identity before and after.
- Gate: the full conformance matrix dialect-on yields a fail-set equal by fixture identity to dialect-off, and every residual difference is recorded with its cause and blocks closure. Documentation alone does not waive parity. Classic 86/86 preserved.
- Typed Bash# `func NAME(...)`, methods and `//` comment fixtures keep passing.
- Workspace and GOWORK=off builds verified; heavy matrix runs once on the remote gate host.
- No change to dialect activation, legacy aliases or shell failure defaults.

Planned owner: claude.

## Execution plan
Follow [Sprint 610 master execution plan](../sprint-610-master-execution-plan.md). Planning only: retain todo status and planned ownership; no implementation, workers, benchmarks or release are authorized. Dependencies and story acceptance remain authoritative.
