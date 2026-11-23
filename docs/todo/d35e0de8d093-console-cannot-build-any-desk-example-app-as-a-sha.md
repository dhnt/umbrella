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
