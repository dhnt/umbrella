# Sprint 670 master execution plan: shaping e2e regression gates

Operator ask (2026-11-19): the five desktop journey checks the operator verified by hand on 2026-11-19 must run end to end automatically, and later changes must not silently break them. Site-owner shaping (a wish that changes an app's source, as in the Hello World example) was never tested end to end either, and gets the same treatment. Releases wait for the gates.

Primary goal: the desktop journey and site-owner shaping run end to end automatically on every affected change and gate the releases; cloudbox v0.18.78 (the always-available navigation) ships only after they pass.

## Stories

| Story | Repo | Scope | Owner | Venue |
|---|---|---|---|---|
| J6 `7c7b5501492f` | hosted control plane (private) | `desktop-journey` scenario in its existing multi-satellite e2e harness: 8 API steps plus browser checks; the affected-paths map routes desktop and UI code to it; the release procedure runs the affected scenarios and blocks on failure | conductor | Linux test host (WSL, narrow podman claim) |
| S1 `0a10de8d63f2` part 1 | bashy | Hello World lifecycle smoke on the release binary, model-free: register → candidate → real checks → preview → approve → second principal unchanged → browser checkpoint → undo → submit; bashy release gate | claude-sonnet5.5 | test host |
| S1 part 2 | bashy + fleet harness | two-host promotion round trip | after part 1 | fleet e2e harness |
| H7a `8793e820356f` | bashy | one budget-capped real-agent Hello World run before each bashy release | after part 1 | test host |
| Navigation `3fea91f32387` | hosted control plane | release v0.18.78 after J6 passes; verify live | conductor | release route |

## Rules

- Smallest change in the existing harnesses; no parallel test framework.
- Every gate must fail on a deliberate break (proven once, recorded).
- Gates run on the self-hosted test host, never the dev box; no podman, ollama or VMs on the dev box.
- Metered bandwidth: no repeated downloads. Release artifacts are cached on the test host, images are built or pulled once, and UI and Go builds use the local caches and existing node_modules offline.
- Releases need the operator's go-ahead.

## Acceptance

J6 and S1 pass on the test host with evidence and a recorded deliberate-break failure; both gates are written into their release procedures; H7a has one recorded real-agent pass; v0.18.78 is released and the navigation is verified live.

## Risks and rollback

A gate that is flaky or slow blocks releases. Keep scenarios deterministic (a canned model by default) and bounded (desktop-journey takes about 6 minutes). Rollback: a gate can be skipped only by an operator-recorded override with a reason in the release packet.
