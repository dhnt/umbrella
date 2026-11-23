---
id: d35e0de8d093
kind: bug
title: 'Console cannot build any desk example app as a shaped member instance: buildServer extracts the app tree alone, so go.mod sibling replaces (../kit, ../chart) are unresolved; incident page + automatic repair calls instead'
seq: 682
status: todo
priority: p0
labels:
    - shaping
    - webconsole
created: 2026-11-23T18:47:53.032542Z
---

Found 2026-11-23 on the gate host during the Sprint 682 C4 preflight (candidate bashy 66a4bb89, yoke 4bafb600). yoke/pkg/webconsole/shaped_server.go buildServer: extractTree(commit) into a temp src, then 'go build -trimpath -o … ./MAIN' with GOWORK=off CGO_ENABLED=0 and cwd=src. examples/desk/{form,notepad,viewer}/go.mod carry 'replace desk-kit => ../kit' and 'replace desk-chart => ../chart'; chart has ../kit; session has ../desk/kit. The extracted tree is the app directory only, so every build fails ('replacement directory ../kit does not exist'); the console serves the self-healing incident page and spends shaping-agent repair calls automatically (repair candidate created for the member). Not a regression: the code is identical at the 11-21 yoke pin; the 11-21 S682 preflight read the incident page ('Genie loader present, no button') as success. Coverage gap: TestDeskToolsShipShapedServer builds in place (siblings present) and never exercises the console path. OPTIONS (operator/sprint decision, not applied): (1) product: in buildServer (and the verifier's candidate build) rewrite relative replace directives to absolute paths under the registered source's parent before building, or extract the referenced sibling trees next to src; (2) apps: make the five example apps self-contained modules (vendor desk-kit/desk-chart or publish them as real modules) and add a test that builds from an extracted tree; (3) both, with the test guarding the console path. Blocks Sprint 682 C4 (five-app member e2e). Evidence: umbrella docs/sprint-682-evidence.md; story 8e5204e127c4 (bashy store). Filed by conductor claude-fable5.1; unowned.

## Operator direction (2026-11-23) and design discussion

**Decision (operator):** do not couple one app with another app's module tree. Every app must build independently of any other app or sibling directory. Rejected: copying `../kit`/`../chart` into the managed repository; vendoring third-party sources into each app; rewriting replace paths at build time. **Chosen direction:** a local Go module proxy.

Design sketch for the follow-up story (not implemented here):
- Shared code (`desk-kit`, `desk-chart`, today replaced by eight apps: calendar, desk/form, desk/chart, desk/page, desk/viewer, desk/notepad, brainstorm/server, session) is published as versioned modules (semver tags or pseudo-versions cut from the bashy checkout) into a local Go module proxy that bashy runs on the host (`bashy mod proxy serve` / `publish`, the GOPROXY protocol: `/@v/list`, `.info`, `.mod`, `.zip`).
- Apps drop their `replace` directives and `require desk-kit vX.Y.Z` (module paths may be renamed to a proper path if the proxy or `go` needs it); `go.sum` carries the proxy-served hashes.
- The console's shaped builds and the verifier's candidate builds set `GOPROXY=<local proxy>,direct` with `GONOSUMDB`/`GOPRIVATE` for those module paths, so an extracted app tree builds anywhere with no sibling on disk; the proxy can also front the public proxy for everything else (relates to yoke story 61c28d52cf73, S516.4: Go module build cache on the S3 layer).
- Registration (`bashy app add --type shaped`) fails loudly, with the fix, when a `go.mod` still has a relative `replace` escaping the source directory.
- Acceptance: a test that registers an app and builds it from the extracted tree with the proxy and no siblings present; the five Sprint 682 apps rebuilt that way on the gate host; then the C4 matrix.

Follow-up story filed in the umbrella store (standalone, unowned) with this sketch; Sprint 682 C4 stays blocked until it lands.
