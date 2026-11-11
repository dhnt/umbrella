# Sprint 615 — Shaping host on free cloud workspaces

Sprint UUID: `899fe465-c505-558d-a1f3-44a74a977e92`. Status: **planning only** — filed 2026-11-10; no implementation started.

## Context

Casual bashy users often have no always-on machine and no satellite or VM
budget. Free third-party cloud dev workspaces combine compute, a browser IDE
and git in one place. Examples are GitHub Codespaces (a monthly free quota on
personal accounts, private repos included), Gitpod/Ona, Firebase Studio and
Google Cloud Shell. This sprint makes such a workspace the **default shaping
host**. The user opens a workspace and bashy and outpost come up. Their shaped
apps (`bashy app serve` + `bashy shape`) are then live through the existing
outpost tunnel at `/h/<host>/app/<name>/`.

**Framing.** Software shaping means an app that always runs in dev mode, for
everyone. Wish, preview, approve and the next wish are development, which is
what these platforms are for.

- Each person shapes in their own free workspace. Approved versions are
  already per-principal.
- Members preview or use a shaped app while its shaping host is running.
- An app that needs to be always on **graduates** to a satellite.
- A workspace is never a satellite or relay, and gets no keep-alive tricks.

## Requirements (operator-confirmed)

| | Requirement | How |
|---|---|---|
| a | **Must:** private GitHub repo as backstore | The workspace is created from the user's own private repo, so the platform token is scoped to it. Shaping state persists via `bashy shape submit/push`. Secrets are never committed. |
| b | **Preferred:** Google identity + Gmail/Drive data access | Reuse `bashy/examples/google` with BYOP onboarding. Each user's own $0 GCP project avoids restricted-scope verification. GitHub stays the backstore. |
| c | **Nice to have:** attach to a shared satellite | `outpost satellite attach` dials out only. Wrap the onboard `accept` + `attach` steps. |

Platform order: **Codespaces first** (a is native), Gitpod second. Firebase
Studio and Cloud Shell are deferred until the first two hold up.

## Current state (surveyed)

- There is no devcontainer, Codespaces or Gitpod support today.
- Outpost dials out and binds loopback only, so it needs no inbound ports.
- `install.sh --no-service` works without sudo or systemd.
- What's missing:
  - a start path without systemd. `outpost service install` errors and tells
    you to run `outpost supervisord`.
  - pairing that survives a workspace rebuild.
  - an explicit stopped-host state.

## Stories (examples first, then optional, then core only if a gap is proven)

| # | Story | Planned vendor |
|---|---|---|
| S1 `bddd4f6e0183` | `examples/shaping-host/shaping-host.bsh` with verbs check / up / status / down / graduate. It detects the platform, installs with `--no-service`, pairs idempotently under a stable host name, starts `outpost supervisord` and serves apps on loopback. Credentials come from platform secrets only. | codex |
| S2 `72f0077803c0` | Shaping starter template: `.devcontainer/devcontainer.json` + `.gitpod.yml`. It opens straight into a shaping session with `examples/shaping/hello-world` live. README with an "Open in" button and the one secret to set. | glm |
| S3 `b95774378a90` | Stopped-host state on the client side: idle timeout and remaining free quota where a platform API allows it. A friendlier offline page for visitors is a hosted-control-plane ticket via the public wire contract only. | claude |
| S4 `e9bffaa179d1` | Google on the shaping host (b). Check first whether the loopback OAuth redirect completes inside a cloud workspace; fall back to `auth-import`. Credentials restored from a platform user secret on `up`. | claude |
| S5 `4e4452889dd8` | Attach to a shared satellite (c). `shaping-host attach INVITE`; `up` re-attaches memberships after a restart. | codex |
| S6 `20ce3526b52a` | Conditional core fix: an outpost start path without systemd. Only if S1 proves the skill-script workaround is not enough. Separate commit. | codex |
| S7 `65f9a8471919` | kb runbook "Shape your apps on a free cloud workspace" (owner role, generic names), linked from the README casual-user and shaping path. | muse |

Not doing: a provider/v1 "workspace provider" (users click "Open in…"
themselves), a satellite or relay role on workspaces, or always-on keep-alive.

## Verification

Done by hand on real free personal accounts. Not on fleet test hosts or the
dev box, and not in hosted CI.

1. "Open in Codespaces" on the template, set the single secret, and the
   workspace comes up. `shaping-host check` reports `platform=codespaces`,
   paired, outpost up.
2. `/h/<host>/app/hello-world/` loads from another device. A wish → preview →
   approve cycle shows the change live, and a member can use the app while the
   session runs.
3. Stop the workspace: the host shows offline. Restart it: the same host name
   comes back without pairing again.
4. (a) Shaping changes are pushed to the private repo. Recreating the
   workspace from that repo restores them.
5. (b) `bashy google auth-status` is green on the host, and a shaped app lists
   Drive files. Credentials survive a rebuild via the user secret.
6. (c) `shaping-host attach` joins a test satellite, and a member opens the
   shared app through it.
7. Repeat steps 1–4 on Gitpod.
8. Run only targeted unit tests for an S6 change. Full gates are deferred to
   QA.
