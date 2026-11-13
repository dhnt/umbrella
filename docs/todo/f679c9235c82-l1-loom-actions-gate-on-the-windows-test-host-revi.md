---
id: f679c9235c82
kind: spike
title: 'L1 loom Actions gate on the Windows test host: review/merge -> push to loom -> build/test automated'
seq: 244
status: todo
priority: p2
labels:
    - loom
    - gate
created: 2026-11-13T18:11:12.870932Z
---

Operator ask (2026-11-13): after the conductor reviews and merges, push to loom and have build/test run there automatically (Gitea Actions), on the Windows test host (the heavy gate venue). Exploration facts (conductor, read-only):

1. loom supports Gitea Actions: yoke/external/loom/loom.go Options.Actions (default on; LOOM_ACTIONS=0 disables), `bashy loom start --actions --expose`. The design is dhnt-docs docs/local-p2p-cicd.md: forge on the hub, act_runner on build nodes dialing OUT over the mesh service `git`, host executor (`runs-on: host`), workflow .gitea/workflows/ci.yml running `bashy dag check/build/test`.
2. The runner: `bashy act-runner register --instance URL --token T` + `bashy act-runner daemon`; outpost has an actrunner builtin (actrunner_instance/_token/_labels config; loom runs as an outpost service unit, `outpost builtins set --service-set loom.ports.0.port=...`). act_runner resolution REFUSES Windows binaries (fail-closed supply-chain policy, S434), so the runner must run in a Linux venue on the test host: the Ubuntu-24.04 WSL distro (bashy rc.33 present, 32 CPUs) or the podman-gate machine. `which go podman git` in that distro printed nothing under `sh -c` (PATH?); verify before relying on it.
3. State today: the dev box loom (primary, port 31880, proxy 31881) is running and holds only outpost, appstore, k3s, hello-tessaro and the pages repos; bashy, yoke and umbrella are NOT on loom. The test host's loom exists (data dir present) but is STOPPED; `loom replica list` from the dev box fails 403 (token not admin). Actions runner-token API on the primary answered 404 for qiangli/bashy (repo absent).
4. Submodule shape: umbrella CI on loom needs every submodule reachable from loom too (or a workflow that fetches siblings from GitHub); simplest first gate = per-subproject repos (bashy, outpost, yoke) with their own ci.yml running the targeted `go test` the stories use, and `make test-bash-container` only on an explicit label.

Proposed setup (needs operator confirmation: it changes host state on the test host and adds a gate venue):
a. On the test host: `bashy loom start --actions --expose` (service unit), create repos bashy/outpost/yoke (or make them replicas of the primary with Actions on the replica; verify mirror-sync pushes trigger Actions in this Gitea version; if not, the conductor pushes directly to the test-host loom as a second remote in the merge step).
b. In the Ubuntu-24.04 WSL distro: `bashy act-runner register --instance <mesh-dialed loom> --labels host:host` + daemon as a service; jobs run natively there, container steps through the podman-gate machine.
c. Workflow: .gitea/workflows/ci.yml per subproject: `go build ./... && go test -short ./...` (yoke/outpost) and `make test` for bashy; the conductor's merge step becomes: review -> merge to main -> push origin (GitHub) AND loom -> read the Actions run status as the gate (`bashy gate --command`).
d. Out of scope now: Zot registry, image builds, ollama.
Done when: one push of a merged Sprint 632 commit to the test-host loom triggers an Actions run whose status the conductor reads, with the evidence on this story.
