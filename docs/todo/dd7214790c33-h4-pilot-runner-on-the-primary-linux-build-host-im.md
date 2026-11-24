---
id: dd7214790c33
kind: task
title: 'H4 pilot runner on the primary Linux build host: image, hosted entry, tunnel to the master, hosted-runner skill-script'
seq: 666
status: todo
priority: p1
labels:
    - bashy-hosting
    - infra
created: 2026-11-23T13:18:04.529734Z
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
