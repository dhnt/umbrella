---
id: 4f8f81c2ad8c
kind: bug
title: 'rc.40 bashy in a no-network sandbox: adapter first use fetches a Go toolchain from go.dev and fails (cloudbox e2e desktop-journey with E2E_LOCAL=1)'
seq: 650
status: todo
priority: p2
labels:
    - adapter
created: 2026-11-23T08:09:34.578774Z
sprint: 693
---

Observed 2026-11-23 00:06 PST in the cloudbox release e2e (script/e2e-multisat.sh, scenario desktop-journey, podman sandbox with no network on the gate host) with E2E_LOCAL=1, i.e. bashy built from umbrella bashy c8650eb4 (the rc.40 thin-core line): fixture step 'member invite <fixture member address>' failed with 'Error: gotoolchain: fetch release index: Get https://go.dev/dl/?mode=json&include=all: dial tcp: lookup go.dev on <sandbox resolver>:53: connect: network is unreachable'. The sealed sandbox has no network by design, and the adapter command (bashy member) is built on first use, so the first use needs a toolchain it cannot fetch. Not a cloudbox defect: the same gate with E2E_LOCAL=0 (released bashy v1.0.0-rc.27 + outpost) is the playbook default and was rerun. For the rc.40 line: sealed/offline venues need a pre-provisioned toolchain or prebuilt adapters (relates to the first-use build stories on Sprint 692 and umbrella 41997de0a4d5). Root cause before fix; file against bashy's adapter first-use path.
