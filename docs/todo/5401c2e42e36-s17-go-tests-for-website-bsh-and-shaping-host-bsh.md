---
id: 5401c2e42e36
kind: test
title: S17 Go tests for website.bsh and shaping-host.bsh against fakes
seq: 483
status: done
priority: p2
labels:
    - shaping
    - examples
    - test
created: 2026-11-18T21:09:25.150598Z
weave: 84
assignee: opencode-glm-5.3
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enabled simple site: showcase MVP on the operator''s résumé site'
closed: 2026-11-18T21:28:15.13722Z
closed_by: claude-opus5.5-s615
---

Planned vendor: zai (opencode glm-5.3). Add bashy/examples/shaping/website/website_test.go (its own go.mod, like bashy/examples/onboard: module github.com/qiangli/bashy/examples/shaping/website, go 1.27) that runs the scripts with the installed bashy (bashy --bashsharp; skip when bashy is not on PATH) against fakes: WEBSITE_OUTPOST_BIN / SHAPING_OUTPOST_BIN point at a small fake script that records argv and answers 'apps secret', 'status --json', 'satellite list --json'; WEBSITE_GO_BIN at a fake go that writes a stub binary; WEBSITE_STATE at t.TempDir(). Cover: enable writes every template file, .devcontainer and bin/{website,shaping-host}.bsh and keeps existing files; enable refuses a title with a quote; serve --dry-run prints the build, apps add --trust-cloud-identity and start lines; register --dry-run prints bashy app add NAME-shaping --type shaped; shaping-host check reports paired/attached from the fake; up with nothing missing runs no register/attach; up unpaired without BASHY_PAIR_CODE exits non-zero naming the secret. Never touch a real outpost or network. Accept: GOWORK=off go -C bashy/examples/shaping/website test ./... green. COMMIT RULES: work only in the files named here; separate commit in the named subproject on its default branch with trailers Sprint: #615 / Story: #<this seq> / Story-ID: <this id> (plus your Agent trailer); never touch other stories' files, never git add -A, never push the umbrella, never bump pins (the conductor does). Targeted unit tests only (GOWORK=off go test for the touched package); no full suites, no containers or VMs on this machine. Public repo: no hostnames, IPs, home paths or real emails; use example.com. Spec: docs/sprint-615-master-execution-plan.md.
