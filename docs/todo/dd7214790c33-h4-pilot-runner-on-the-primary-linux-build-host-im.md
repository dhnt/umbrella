---
id: dd7214790c33
kind: task
title: 'H4 pilot runner on the primary Linux build host: image, hosted entry, tunnel to the master, hosted-runner skill-script'
seq: 666
status: assigned
priority: p1
labels:
    - bashy-hosting
    - infra
created: 2026-11-23T13:18:04.529734Z
weave: 239
assignee: agy-gemini4-hydrogen
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Start brief 2026-11-24 (conductor). Staffing: agy (Gemini only). Merged inputs: bashy main carries H1 `mcp serve --hosted` (5d160655), H1b approvals (c2443b89), H2 vault projection (d69d9e95), H6/H6b trove (29cd8db6, 60597c1b); yoke d069a0f5.

Venue: the gate host's Linux distro (the Windows gate host; find its alias with `bashy outpost peers status`), reached with the direct mesh form of `outpost ssh` (not the relayed `ssh exec`). Take `bashy claim resource:<alias>.lane1 --intent "Sprint 691 H4 pilot"` before any build and release it when done. Never touch the host's default podman machine (it runs a live service); use podman inside the Linux distro. Never build on the dev box.

Work in small committed steps (the run stops at 48 min):
1. `bashy/examples/hosted-runner/` Bash# skill-script (`build|start|stop|status`, `--json`, `--dry-run`): image from `bashy/tools/bashy-build/Containerfile.base` plus a bashy built from main and the google + trove examples registered; pre-warm the adapter cache (secret, jq, lens, sha256sum) so calls do not build adapters; entry `bashy mcp serve --transport http --hosted --listen 127.0.0.1:PORT` with the runner key file 0600 from a test key generated on the host (never committed).
2. A fake master signer (a small test helper in the example, test key only) that signs `X-Bashy-Hosted-Identity` exactly as H1 verifies, and one call: `run_tool echo` returns its output, the scratch is gone afterwards, a replay answers `replayed`, an unsigned call answers 401.
3. Over the tunnel: expose the runner on the host's outpost as an app and make the same signed call from the dev box through the existing host-app route, if that route admits it without any hosted-plane change; if it does not, record exactly why on the story (that is H3 ticket territory) and stop there.
Record per-call latency and runner RSS from the steps that ran (input for H5). Live gateway `route: hosted` is a Sprint 699 train item, not this story.

Planned vendor: agy. Image from bashy/tools/bashy-build/Containerfile.base + release bashy + the google example registered; entry bashy mcp serve --transport http --hosted --listen 127.0.0.1:PORT; one handler per call (Knative/Fission later, per the research); tunnel to the master; written as examples/hosted-runner/ Bash# skill-script (build|start|stop|status, --json) so the pilot is reproducible; host taken with bashy claim and released after. Accept (MVP rescope 2026-11-24): image builds on the build host (never the dev box); a call signed by a fake master signer (test key, same per-call identity format as H1) reaches the runner over the tunnel and returns a bashy result, with scratch removed after; the live gateway call answering route: hosted is a release-train item (Sprint 699 goal hosted-route-t1), not this story; pilot allocation per the research note referenced from story 3211. Depends on H1 and H2; the H3 master ticket gates only the train item. Spec: docs/sprint-691-master-execution-plan.md

## Delivery 2026-11-24 (agy-gemini4-hydrogen)

- **Code (`bashy`):**
  - `internal/agentos/mcp_hosted.go` (`mcpHostedCall.env`), `internal/agentos/mcp_hosted_test.go`, `docs/mcp-server.md`: preserve runner `BASHY_ADAPTER_CACHE` and `BASHY_BIN_CACHE` in hosted child processes (unoverridable by client `env`), so pre-warmed adapters (`secret`, `jq`, `lens`, `sha256sum`) run without compiling in scratch.
  - `examples/hosted-runner/`: `hosted-runner.bsh` (`build|start|stop|status`, `--json`, `--dry-run`, `--skill`), `Containerfile` (derived from `tools/bashy-build/Containerfile.base` + `bashy` from `main` + `google` and `trove` registered + pre-warmed `BASHY_ADAPTER_CACHE`), `register.sh`, `README.md`, `go.mod`, `hosted_runner_test.go`, and `cmd/signer/` (fake master signer test helper + `standalone_deps_test.go`).
- **Build & local verification on the Windows gate host's Linux distro (under `resource:<alias>.lane1`, podman inside the distro; default podman machine untouched):**
  - `hosted-runner.bsh build --json` built `localhost/bashy-hosted-base:latest` from `tools/bashy-build/Containerfile.base` and `localhost/bashy-hosted-runner:latest` with `google` + `trove` registered and `secret`, `jq`, `lens`, `sha256sum` pre-warmed.
  - `hosted-runner.bsh start --port 22751 --json`: container running and healthy (`401` on unsigned `/mcp`), initial runner `VmRSS` `159744 KB` (~156 MiB).
  - `cmd/signer --url http://127.0.0.1:22751/mcp --verify --json`:
    - unsigned `POST /mcp`: HTTP `401`, `0.82 ms`
    - `tools/list`: `12` tools (`google` and `trove` present; `shell_open`/`shell_exec`/`shell_close` absent)
    - `run_tool echo`: HTTP `200`, `exit_code=0`, `stdout="hello hosted\n"`, `81.54 ms`
    - replay (same `idempotency_key`): HTTP `200`, `state="replayed"`, `3.51 ms`
    - pre-warmed adapter smoke (`bashy jq -n "40+2" && bashy sha256sum /dev/null` via `bashy` script tool): HTTP `200`, `exit_code=0`, `504.66 ms`
    - `hosted-runner.bsh status`: `scratch_entries=0`, `VmRSS=163156 KB` (~159 MiB).
- **Over-tunnel verification from the dev box:**
  - Exposed on the Windows gate host's outpost as app `hosted-runner-pilot` (`--scheme http --host 127.0.0.1 --port 22751`, `require_login=false`), reachable through the attached satellite's existing host-app route (`/matrix/h/<host>/app/hosted-runner-pilot/mcp`).
  - `cmd/signer --verify --json` from the dev box over the satellite tunnel:
    - unsigned `POST /mcp`: HTTP `401`, `156.83 ms`
    - `tools/list`: `12` tools (`google=true`, `trove=true`, session tools absent)
    - `run_tool echo`: HTTP `200`, `exit_code=0`, `stdout="hello hosted\n"`, `153.81 ms`
    - replay: HTTP `200`, `state="replayed"`, `82.91 ms`
    - post-tunnel `hosted-runner.bsh status`: `scratch_entries=0`, `VmRSS=147884 KB` (~144 MiB).
  - Note for H3/H5: hitting the direct portal (`/matrix/h/<host>/app/...`) returned `403 csrf token missing or invalid` without CSRF/Bearer and `404` when the host is identity-only and tunnels through an attached satellite; on the attached satellite's host-app route with `require_login=false`, requests pass `X-Bashy-Hosted-Identity` through cleanly, but rapid back-to-back calls hit the satellite's `anon` rate limiter (`HTTP 429 {"class":"anon","error":"rate limit exceeded","limit_per_min":60}`) because a host-app route without a web session falls into the `anon` bucket (H3 ticket territory for dedicated `route: hosted` dispatch).
  - Cleaned up temporary outpost app, container, host scratch/key files, and released `resource:<alias>.lane1`.

Merged 2026-11-24 by the conductor: bashy 71bea470..b02bff44 fast-forwarded to main. Conductor rerun: TestMCP|TestSkillHelpGoldens|TestSrcPins ok. Review notes: the shared adapter cache is root-owned and read-only to the runner uid, so callers cannot poison it; an adapter that is not pre-warmed cannot build into it (known limit, image must pre-warm what it serves). The tunnel check used a temporary host app on the satellite host-app route and hit its anonymous rate limit (60/min): load through it needs the H3 route (cloudbox eed85934); H5 measures the runner directly on the host.
