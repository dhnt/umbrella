---
id: a297eccbbfd8
kind: task
title: 'M6 Lifted surface whose code spans a second module: cite its pinned go tests and grade its candidate'
seq: 862
status: done
created: 2026-11-28T10:19:44.398526Z
assignee: claude-opus5.5-s741
sprint: 742
sprint_id: 7dde34d4-f382-5aba-8ff5-071c5e3548b8
sprint_title: 'Shaping: bugs and issues become spec changes (issue-to-spec support)'
closed: 2026-11-28T10:50:08.747746Z
closed_by: claude-opus5.5-s741
---

Found while moving bashy sprint 744 (agent identity: N1 per-launch session id, N2 ad hoc identity for native agent sessions, N3 front-door identity step) onto the shapeware process. The surface is bashy CLI behaviour, but most of the code and its pinned tests are in the yoke repository, which bashy consumes by a versioned go.mod pin, and in bashy's nested yoke/ module. Sprint 742's Go-backed surface (spec 4.3b, 6, Appendix D) assumes one repository and one root module, so this surface cannot be fully specified yet.
Gaps, each checked against the delivered code:
1. gotest cannot name a test outside the implementation's root module. conform spec check rule gotest-form (conform 75bc1c2, spec/shapeware.go badGoPackage) accepts only '.' or a clean './path'; the launcher runs go test in the implementation root. The tests that pin this surface are github.com/qiangli/yoke/pkg/chat (TestJoinAdHoc...), github.com/qiangli/yoke/pkg/bus (TestAdHocIdentity..., TestStampAdHocIdentity...) and bashy's nested module ./yoke/mb, ./yoke/inbox, none of which is a './path' package of the bashy root module.
2. candidate-files is one repository's globs. A change made in the dependency reaches the surface's repository only as pin lines (go.mod, go.sum in five modules, one source pin). The spec does not say how such a candidate is declared, built or reviewed: whether the pin lines are the candidate, where the dependency's own diff is graded, and that the dependency commit must be published (and served by the checksum database, which lagged 10 to 30 minutes on each of three bumps) before the candidate can build standalone.
3. No way to assert a live terminal session. The contract runner (conform contract/run.go) runs commands through sh -c with no terminal, so the session id a real 'bashy <tool>' launch prints, and 'bashy chat sessions' while it is live, can only be reached through a cited go test (blocked by gap 1) or through --dry-run text.
Wanted (smallest forms; pick per gap): a gotest form that names a module directory or a dependency import path; a rule for a pin-only candidate; a note on what a surface with a terminal session may assert. Not asking for all three before 744 moves: gap 1 alone unblocks most of it.
Not gaps: a CLI surface needs no serve/request launcher (4.3a covers it, as bashy shapeware/shape shows); environment for a command is set by the surface's judge.
Code inspected: conform spec/shapeware.go, contract/run.go; umbrella docs/shapeware-spec-v0.md 4.3a, 4.3b, 6, 6a; bashy examples/shapeware/lifted-surface/scripts/launcher.sh, shapeware/shape.
