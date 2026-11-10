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

## Outcome
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
