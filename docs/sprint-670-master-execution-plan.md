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

## Delivery continuation (2026-11-20)

Operator appointed the Codex manager to finish the remaining S1 and H7a stories. J6/navigation remain accepted; the existing S1 model-free result is retained. Internal workers prepare isolated implementation candidates; the manager reviews and runs the acceptance gates independently.

1. Complete S1 using two disposable Linux containers and real Git transport over a private network. Reuse the existing cached image and candidate for reproduction. The first product failure is the registered `hello-world` app being rejected by the source-repository allowlist during `shape remote set`. Repair only explicit app-promotion configuration, retaining the source-download allowlist, with regression coverage for both boundaries.
2. Run focused source/promotion/CLI tests and build the candidate on the existing official-image test venue. Qualify the two-host gate and its deliberate broken-ref control; retain exact source, image, binary and evidence identities.
3. Complete H7a with one bounded real-agent generation through the production delegate, then actual verifier, browser preview/approval, second-principal isolation and undo. Use the existing authenticated low-cost agent on the macOS test host with private run state and credential references. No prepared-edit substitute, automatic model retry or browser skip.
4. Integrate only passing reviewed changes, publish producer commits before consumer pins, update release procedures and acceptance records, and close the sprint after its end checks pass. No release or deployment is part of this continuation.

Resource budget: cached images/modules, focused tests only, two 2-CPU/2-GiB promotion containers, one model generation capped at 600 seconds. Missing prerequisites and product failures remain explicit until resolved; historical failures are retained separately from passing reruns.

S1 is accepted and published (Yoke `79e1473d`, Bashy `5a0a79be`, `58dd639c`, acceptance `b5477087`). H7a first provider invocation stopped at a denied read-only Git command under accept-edits mode; no edit occurred. Following documented provider semantics, the manager extends the estimate to one additional capped invocation using sandboxed Auto mode, retaining the failed transcript and all assertions. This is an explicit corrective attempt after diagnosis, not an automatic retry.

The corrective H7a invocation made the requested edit; a fixture assertion then compared source and imported commit IDs despite identical trees. After confirming the unchanged source reflog/worktree, snapshot the correct pre-wish source HEAD and allow one final 600-second-capped full qualification. Retain both provider-attempt records; do not count their failed gates as passing.


## Delivery result

All four stories are accepted. J6 and navigation retain their previous accepted
release evidence. S1 promotion passes 23 checks plus targeted broken-ref failure;
model-free lifecycle passes 27 checks plus the broken-verifier control. H7a now
passes 38 checks with one real production delegate invocation and six browser
observations. Earlier failed attempts remain recorded on the stories.

Yoke `79e1473d` and Bashy `5a0a79be`, `58dd639c`, `c76d09f1` are published.
Six CLI tests and 180 source/shape tests pass; three existing Windows-only cases
are skipped on Linux. Standalone published-pin Linux, macOS and Windows builds
pass. Production-input hashes match the tested binaries. Functional promotion
fixtures and runner are unchanged by the later real-agent fixture/documentation
repairs. The final closure check reruns the model-free lifecycle on the exact
native candidate and committed driver; it reuses the separately retained real-agent
and promotion evidence rather than spending another model invocation.

The continuation delivered no release or deployment. Test claims are released
after the closure gate, and private evidence is retained outside the public repo.


Closure passed in the same `GOWORK=off` configuration used by the standalone
candidate builds, with a fresh 27-check native lifecycle pass. Other sprints
advanced the shared producer checkout concurrently; those later commits were
not part of this candidate. The umbrella pins the tested, published Yoke
`79e1473d` explicitly, while the shared checkout and other agents' work remain
untouched. Both remaining stories and the sprint are closed.
